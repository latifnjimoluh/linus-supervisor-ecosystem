// controllers/terminal/listTerminalVMs.js
const axios = require('axios');
const https = require('https');
const ping = require('ping');
const { Op, Sequelize } = require('sequelize');
const { Deployment, UserSetting } = require('../../models');
const { logAction } = require('../../middlewares/log');

const httpsAgent = new https.Agent({ rejectUnauthorized: false }); // on garde ta logique actuelle
const AGENT_CONCURRENCY = parseInt(process.env.PROXMOX_AGENT_CONCURRENCY || '6', 10);

// --------- Helpers IP ----------
const isPrivate = (ip) =>
  ip?.startsWith('10.') ||
  ip?.startsWith('192.168.') ||
  (ip?.startsWith('172.') && (() => {
    const o = parseInt(ip.split('.')[1], 10);
    return o >= 16 && o <= 31;
  })());

function pickBestIPv4(niResult = []) {
  const list = [];
  for (const iface of niResult) {
    const addrs = Array.isArray(iface['ip-addresses']) ? iface['ip-addresses'] : [];
    for (const a of addrs) {
      const ip = a['ip-address'];
      if (a['ip-address-type'] === 'ipv4' && ip && ip !== '127.0.0.1' && !ip.startsWith('169.254.')) {
        list.push(ip);
      }
    }
  }
  return list.find(isPrivate) || list[0] || null;
}

// --------- DB helpers ----------
async function getLatestVmIpAndInstanceId(vmId) {
  const row = await Deployment.findOne({
    attributes: ['vm_ip', 'instance_id'],
    where: {
      vm_id: String(vmId), // vm_id est VARCHAR dans ta BD
      operation_type: 'apply',
      success: true,
      status: { [Op.in]: ['deployed', 'apply'] },
      vm_ip: { [Op.ne]: null },
    },
    order: [[Sequelize.literal('COALESCE("ended_at","updated_at","started_at")'), 'DESC']],
  });
  return row ? { ip: row.vm_ip, instance_id: row.instance_id } : { ip: null, instance_id: null };
}

async function upsertLastApplyIP(vmId, ip) {
  if (!ip) return;
  const row = await Deployment.findOne({
    attributes: ['id'],
    where: {
      vm_id: String(vmId), // vm_id est VARCHAR
      operation_type: 'apply',
      success: true,
      status: { [Op.in]: ['deployed', 'apply'] },
    },
    order: [[Sequelize.literal('COALESCE("ended_at","updated_at","started_at")'), 'DESC']],
  });
  if (row) {
    await Deployment.update({ vm_ip: ip }, { where: { id: row.id } });
  }
}

// --------- Limiteur de concurrence (sans dépendance) ----------
async function mapLimited(items, limit, mapper) {
  const results = new Array(items.length);
  let cursor = 0;
  const workers = new Array(Math.min(limit, items.length)).fill(null).map(async () => {
    while (true) {
      const i = cursor++;
      if (i >= items.length) break;
      results[i] = await mapper(items[i], i);
    }
  });
  await Promise.all(workers);
  return results;
}

// --------- Controller ----------
exports.listTerminalVMs = async (req, res) => {
  try {
    const settings = await UserSetting.findOne({ where: { user_id: req.user.id } });
    if (!settings) {
      return res.status(404).json({ message: 'Paramètres Proxmox introuvables.' });
    }

    const headers = {
      Authorization: `PVEAPIToken=${settings.proxmox_api_token_id}!${settings.proxmox_api_token_name}=${settings.proxmox_api_token_secret}`,
    };

    // 1) Lister toutes les VMs (Proxmox)
    const listUrl = `${settings.proxmox_api_url}/cluster/resources?type=vm`;
    const { data: listResp } = await axios.get(listUrl, { httpsAgent, headers });
    const all = Array.isArray(listResp?.data) ? listResp.data : [];

    // garder uniquement les QEMU non templates
    const vms = all.filter(v => v.type === 'qemu' && !v.template);

    // 2) Pour chaque VM : IP via BDD; sinon fallback agent si running + ping + ip_source
    const results = await mapLimited(vms, AGENT_CONCURRENCY, async (vm) => {
      const vmid = String(vm.vmid);
      const node = vm.node;
      const status = vm.status; // running / stopped

      let ip_source = null;
      let ping_ok = null;

      let { ip, instance_id } = await getLatestVmIpAndInstanceId(vmid);
      if (ip) ip_source = 'db';

      if (!ip && status === 'running' && node) {
        try {
          const agentUrl = `${settings.proxmox_api_url}/nodes/${encodeURIComponent(node)}/qemu/${encodeURIComponent(vmid)}/agent/network-get-interfaces`;
          const { data: agentResp } = await axios.get(agentUrl, { httpsAgent, headers });
          const ipCandidate = pickBestIPv4(agentResp?.data?.result || []);
          if (ipCandidate) {
            ip = ipCandidate;
            ip_source = 'agent';
            // persiste l'IP trouvée dans la dernière entrée apply/success
            await upsertLastApplyIP(vmid, ipCandidate);
          }
        } catch (e) {
          if (process.env.LOG_AGENT_ERRORS === 'true') {
            console.info(`[QEMU Agent] ${node}/${vmid}: ${e?.message || e}`);
          }
        }
      }

      // ping si VM running et IP dispo
      if (ip && status === 'running') {
        try {
          const r = await ping.promise.probe(ip, { timeout: 2 });
          ping_ok = !!r.alive;
        } catch {
          ping_ok = null;
        }
      }

      return {
        id: vmid,
        name: vm.name,
        status,
        ip,
        instance_id,
        node,
        type: vm.type, // 'qemu'
        ip_source,     // 'db' | 'agent' | null
        ping_ok,       // true | false | null
      };
    });

    // 3) Filtrage optionnel : uniquement les VMs connectables
    const onlyConnectable = String(req.query.onlyConnectable || '').toLowerCase() === 'true';
    const payload = onlyConnectable
      ? results.filter(r => r.status === 'running' && r.ip)
      : results;

    await logAction(req, 'terminal_list_vms');
    return res.json(payload);
  } catch (err) {
    console.error('❌ Erreur listTerminalVMs:', err);
    if (err.response?.status === 401) {
      return res.status(401).json({ code: 'DEPLOY_AUTH_401', message: 'Authentification Proxmox invalide.' });
    }
    if (err.code === 'ECONNREFUSED' || err.code === 'ENOTFOUND') {
      return res.status(502).json({ code: 'MAP_PROXMOX_DOWN', message: 'Proxmox injoignable.' });
    }
    return res.status(500).json({ code: 'TERMINAL_LIST_ERROR', message: 'Erreur serveur.' });
  }
};
