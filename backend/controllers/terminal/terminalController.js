// controllers/terminal/listTerminalVMs.js
const axios = require('axios');
const https = require('https');
const ping = require('ping');
const { Op, Sequelize } = require('sequelize');
const { Deployment, UserSetting } = require('../../models');
const { logAction } = require('../../middlewares/log');

const httpsAgent = new https.Agent({ rejectUnauthorized: false });
const AGENT_CONCURRENCY = parseInt(process.env.PROXMOX_AGENT_CONCURRENCY || '6', 10);
const DB_CANDIDATE_LIMIT = parseInt(process.env.TERMINAL_DB_IP_CANDIDATES || '5', 10);

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
  // Priorité aux IP privées si présentes
  return list.find(isPrivate) || list[0] || null;
}

async function probe(ip, timeout = 2) {
  try {
    const r = await ping.promise.probe(ip, { timeout });
    return !!r.alive;
  } catch {
    return false;
  }
}

// --------- DB helpers ----------
// On récupère plusieurs dernières IP candidates (apply/success/ended_at non null),
// triées par fin d’opération la plus récente.
async function getLatestVmIpCandidates(vmId, limit = DB_CANDIDATE_LIMIT) {
  const rows = await Deployment.findAll({
    attributes: ['id', 'vm_ip', 'instance_id', 'ended_at'],
    where: {
      vm_id: String(vmId),
      operation_type: 'apply',
      success: true,
      ended_at: { [Op.ne]: null },
      vm_ip: { [Op.ne]: null },
    },
    order: [
      ['ended_at', 'DESC'],
      ['id', 'DESC'],
    ],
    limit,
  });

  // dédupliquer sur l'IP en gardant l’ordre
  const seen = new Set();
  const unique = [];
  for (const r of rows) {
    const ip = r.vm_ip;
    if (ip && !seen.has(ip)) {
      seen.add(ip);
      unique.push({ ip, instance_id: r.instance_id });
    }
  }
  return unique;
}

async function upsertLastApplyIP(vmId, ip) {
  if (!ip) return;
  const row = await Deployment.findOne({
    attributes: ['id'],
    where: {
      vm_id: String(vmId),
      operation_type: 'apply',
      success: true,
      ended_at: { [Op.ne]: null },
    },
    order: [
      ['ended_at', 'DESC'],
      ['id', 'DESC'],
    ],
  });
  if (row) {
    await Deployment.update({ vm_ip: ip }, { where: { id: row.id } });
  }
}

// --------- Limiteur de concurrence ----------
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

    // 2) Pour chaque VM : on construit une liste de candidates (agent + DB) puis on choisit la « meilleure »
    const results = await mapLimited(vms, AGENT_CONCURRENCY, async (vm) => {
      const vmid = String(vm.vmid);
      const node = vm.node;
      const status = vm.status; // running / stopped

      let chosenIp = null;
      let chosenSource = null;
      let ping_ok = null;
      let chosenInstanceId = null;

      // 2.a) Candidats DB (plusieurs)
      const dbCandidates = await getLatestVmIpCandidates(vmid); // [{ip, instance_id}, ...]

      // 2.b) Candidat Agent (si running)
      let agentIp = null;
      if (status === 'running' && node) {
        try {
          const agentUrl = `${settings.proxmox_api_url}/nodes/${encodeURIComponent(node)}/qemu/${encodeURIComponent(vmid)}/agent/network-get-interfaces`;
          const { data: agentResp } = await axios.get(agentUrl, { httpsAgent, headers });
          const ipCandidate = pickBestIPv4(agentResp?.data?.result || []);
          if (ipCandidate && isPrivate(ipCandidate)) {
            agentIp = ipCandidate;
          }
        } catch (e) {
          if (process.env.LOG_AGENT_ERRORS === 'true') {
            console.info(`[QEMU Agent] ${node}/${vmid}: ${e?.message || e}`);
          }
        }
      }

      // 2.c) Ordre de préférence :
      // 1) Agent (réseau réel) si reachable
      // 2) Sinon, première DB qui ping
      // 3) Sinon, Agent même si ne ping pas (pare-feu ICMP souvent fermé)
      // 4) Sinon, 1ère DB (fallback)
      if (agentIp) {
        if (status === 'running') {
          const alive = await probe(agentIp);
          if (alive) {
            chosenIp = agentIp;
            chosenSource = 'agent';
          }
        }
      }

      if (!chosenIp && dbCandidates.length > 0) {
        for (const c of dbCandidates) {
          // ping seulement si VM running; sinon on ne sait pas répondre => on prend quand même cette IP plus tard
          if (status === 'running') {
            const alive = await probe(c.ip);
            if (alive) {
              chosenIp = c.ip;
              chosenSource = 'db';
              chosenInstanceId = c.instance_id || null;
              break;
            }
          }
        }
      }

      if (!chosenIp && agentIp) {
        // pare-feu ICMP fréquent : on fait confiance à l’agent même si ping KO
        chosenIp = agentIp;
        chosenSource = 'agent';
      }

      if (!chosenIp && dbCandidates.length > 0) {
        // dernier recours : la plus récente en BDD
        chosenIp = dbCandidates[0].ip;
        chosenSource = 'db';
        chosenInstanceId = dbCandidates[0].instance_id || null;
      }

      // 2.d) Persistance si on a corrigé via l’agent
      if (chosenIp && chosenSource === 'agent') {
        // remonter l’IP la plus récente pour « réparer » la dernière apply
        await upsertLastApplyIP(vmid, chosenIp);
      }

      // 2.e) Ping final (info UI)
      if (chosenIp && status === 'running') {
        ping_ok = await probe(chosenIp);
      }

      return {
        id: vmid,
        name: vm.name,
        status,
        ip: chosenIp || null,
        instance_id: chosenInstanceId || null,
        node,
        type: vm.type,        // 'qemu'
        ip_source: chosenSource, // 'db' | 'agent' | null
        ping_ok,              // true | false | null
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
