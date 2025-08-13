const fs = require('fs');
const path = require('path');
const ping = require('ping');
const { Op } = require('sequelize');
const { UserSetting, ConvertedVm, User, Deployment, Delete } = require('../../models');
const { logAction } = require('../../middlewares/log');
const { execSSHCommand } = require('../../utils/sshClient');
const { ProxmoxService } = require('../../services/proxmoxService');

// 🖥️ Lister toutes les VM depuis Proxmox
exports.listVMs = async (req, res) => {
  console.log('📥 listVMs called for user', req.user?.id);
  try {
    const settings = await UserSetting.findOne({ where: { user_id: req.user.id } });
    if (!settings) {
      console.log('⚠️ Paramètres Proxmox introuvables');
      return res.status(404).json({ message: 'Paramètres Proxmox introuvables.' });
    }

    const s = settings.get({ plain: true });
    const client = new ProxmoxService(s);

    // ProxmoxService.get() renvoie déjà un tableau (payload "déballé")
    const rows = await client.get('/cluster/resources?type=vm');
    const all = Array.isArray(rows) ? rows : [];

    const vms = all.filter((r) => r.type === 'qemu' && r.template === 0);
    const templates = all.filter((r) => r.type === 'qemu' && r.template === 1);

    console.log(`📤 ${vms.length} VMs et ${templates.length} templates récupérés`);
    await logAction(req, 'list_vms');
    res.json({ vms, templates });
  } catch (err) {
    console.error('❌ Erreur listVMs:', err.message);
    res.status(500).json({ message: 'Erreur serveur.' });
  }
};

exports.listNodes = async (req, res) => {
  try {
    const settings = await UserSetting.findOne({ where: { user_id: req.user.id } });
    if (!settings) return res.status(404).json({ message: 'Paramètres Proxmox introuvables.' });

    const s = settings.get({ plain: true });
    const client = new ProxmoxService({
      proxmox_api_url: s.proxmox_api_url,
      proxmox_api_token_id: s.proxmox_api_token_id,
      proxmox_api_token_name: s.proxmox_api_token_name,
      proxmox_api_token_secret: s.proxmox_api_token_secret,
      proxmox_node: s.proxmox_node, // optionnel ici
    });

    const rows = await client.get('/nodes');
    const nodes = (Array.isArray(rows) ? rows : []).map((n) => ({ node: n.node, status: n.status }));
    res.json(nodes);
  } catch (err) {
    console.error('❌ Erreur listNodes:', err.stack || err.message);
    res.status(500).json({ message: 'Erreur serveur.' });
  }
};

// 📦 Lister les stockages disponibles (avec espace libre)
exports.listStorages = async (req, res) => {
  try {
    const settings = await UserSetting.findOne({ where: { user_id: req.user.id } });
    if (!settings) {
      return res.status(404).json({ message: 'Paramètres Proxmox introuvables.' });
    }

    const s = settings.get({ plain: true });
    const targetNode = req.query.node || s.proxmox_node;
    if (!targetNode) {
      return res.status(400).json({ message: 'Nœud Proxmox non spécifié.' });
    }

    const client = new ProxmoxService({
      proxmox_api_url: s.proxmox_api_url,
      proxmox_api_token_id: s.proxmox_api_token_id,
      proxmox_api_token_name: s.proxmox_api_token_name,
      proxmox_api_token_secret: s.proxmox_api_token_secret,
      proxmox_node: targetNode,
    });

    const rows = await client.get('/cluster/resources?type=storage');
    const all = Array.isArray(rows) ? rows : [];

    const storages = all
      .filter((st) => st.type === 'storage' && st.status === 'available' && (!st.node || st.node === client.node))
      .map((st) => {
        const total = Number(st.maxdisk || 0);
        const used = Number(st.disk || 0);
        const free = Math.max(total - used, 0);
        return {
          storage: st.storage,
          content: st.content,
          plugintype: st.plugintype,
          node: st.node || client.node,
          shared: !!st.shared,
          total_bytes: total,
          used_bytes: used,
          free_bytes: free,
        };
      });

    res.json(storages);
  } catch (err) {
    console.error('❌ Erreur listStorages:', err.stack || err.message);
    res.status(500).json({ message: 'Erreur serveur.' });
  }
};

// ℹ️ Informations système d'un nœud
exports.getSystemInfo = async (req, res) => {
  try {
    const settings = await UserSetting.findOne({ where: { user_id: req.user.id } });
    if (!settings) {
      return res.status(404).json({ message: 'Paramètres Proxmox introuvables.' });
    }

    const s = settings.get({ plain: true });
    const targetNode = req.query.node || s.proxmox_node;
    if (!targetNode) {
      return res.status(400).json({ message: 'Nœud Proxmox non spécifié.' });
    }

    const client = new ProxmoxService({
      proxmox_api_url: s.proxmox_api_url,
      proxmox_api_token_id: s.proxmox_api_token_id,
      proxmox_api_token_name: s.proxmox_api_token_name,
      proxmox_api_token_secret: s.proxmox_api_token_secret,
      proxmox_node: targetNode,
    });

    // get() renvoie l'objet status directement (déballé)
    const status = await client.get(`/nodes/${client.node}/status`);
    const mem = status?.memory || {};
    const rootfs = status?.rootfs || {};
    const cpuinfo = status?.cpuinfo || {};

    const memTotal = Number(mem.total || 0);
    const memUsed = Number(mem.used || 0);
    const memFree = Math.max(memTotal - memUsed, 0);

    const diskTotal = Number(rootfs.total || 0);
    const diskUsed = Number(rootfs.used || 0);
    const diskFree = Math.max(diskTotal - diskUsed, 0);

    res.json({
      node: client.node,
      memory: { total: memTotal, used: memUsed, free: memFree },
      disk: { total: diskTotal, used: diskUsed, free: diskFree },
      cpu: {
        cores: cpuinfo.cores || 0,
        sockets: cpuinfo.sockets || 0,
        usage: typeof status?.cpu === 'number' ? status.cpu : null, // ratio 0..1
      },
    });
  } catch (err) {
    console.error('❌ Erreur getSystemInfo:', err.stack || err.message);
    res.status(500).json({ message: 'Erreur serveur.' });
  }
};

// ▶️ Démarrer une VM
exports.startVM = async (req, res) => {
  const vmId = req.params.vmId;
  console.log('📥 startVM called for VM', vmId);
  try {
    const settings = await UserSetting.findOne({ where: { user_id: req.user.id } });
    if (!settings) return res.status(404).json({ message: 'Paramètres Proxmox introuvables.' });

    const s = settings.get({ plain: true });
    const client = new ProxmoxService(s);

    await client.post(`/nodes/${client.node}/qemu/${vmId}/status/start`);

    await logAction(req, `start_vm:${vmId}`);
    res.json({ message: `VM ${vmId} démarrée.` });
  } catch (err) {
    console.error('❌ Erreur startVM:', err.message);
    res.status(500).json({ message: 'Erreur démarrage VM.' });
  }
};

// ⏹️ Stopper une VM
exports.stopVM = async (req, res) => {
  const vmId = req.params.vmId;
  console.log('📥 stopVM called for VM', vmId);
  try {
    const settings = await UserSetting.findOne({ where: { user_id: req.user.id } });
    if (!settings) return res.status(404).json({ message: 'Paramètres Proxmox introuvables.' });

    const s = settings.get({ plain: true });
    const client = new ProxmoxService(s);

    await client.post(`/nodes/${client.node}/qemu/${vmId}/status/stop`);

    await logAction(req, `stop_vm:${vmId}`);
    res.json({ message: `VM ${vmId} arrêtée.` });
  } catch (err) {
    console.error('❌ Erreur stopVM:', err.message);
    res.status(500).json({ message: 'Erreur arrêt VM.' });
  }
};

async function getVMStatus(client, vmId) {
  try {
    const obj = await client.get(`/nodes/${client.node}/qemu/${vmId}/status/current`);
    return obj?.status;
  } catch (err) {
    console.error('❌ Erreur getVMStatus :', err.message);
    throw err;
  }
}

async function deleteVM(client, vmId) {
  return client.delete(`/nodes/${client.node}/qemu/${vmId}`);
}

async function getVMInfo(client, vmId) {
  // get() renvoie déjà l'objet config
  return client.get(`/nodes/${client.node}/qemu/${vmId}/config`);
}

async function getVMIP(client, vmId) {
  try {
    // Réponse déballée : { result: [ ...interfaces ] }
    const payload = await client.get(`/nodes/${client.node}/qemu/${vmId}/agent/network-get-interfaces`);
    const interfaces = payload?.result || payload || [];
    for (const iface of interfaces) {
      const addresses = iface['ip-addresses'] || iface['ip_addresses'] || [];
      for (const addr of addresses) {
        const ip = addr['ip-address'] || addr.address;
        if (ip && ip !== '127.0.0.1' && ip.includes('.')) {
          return ip;
        }
      }
    }
    return null;
  } catch (err) {
    console.error('❌ Erreur getVMIP :', err.message);
    return null;
  }
}

async function isPingable(ip) {
  try {
    const result = await ping.promise.probe(ip);
    return result.alive;
  } catch (err) {
    console.error('❌ Erreur ping :', err.message);
    return false;
  }
}

// ✅ Vérifier l'état d'une VM et sa réponse au ping
exports.checkVMStatus = async (req, res) => {
  console.log('📥 checkVMStatus called', req.body);
  const userId = req.user?.id;

  const {
    vm_id,
    node: bodyNode,
    ip_address: bodyIP,
    proxmox_api_url,
    proxmox_api_token_id,
    proxmox_api_token_name,
    proxmox_api_token_secret,
  } = req.body;

  if (!vm_id) {
    return res.status(400).json({ message: '❌ vm_id requis' });
  }

  try {
    const settings = await UserSetting.findOne({ where: { user_id: userId } });
    if (!settings) {
      return res.status(404).json({ message: '❌ Paramètres utilisateur introuvables' });
    }

    const s = settings.get({ plain: true });

    const node = bodyNode || s.proxmox_node;
    const ip_address = bodyIP || s.last_used_ip || null;
    const apiUrl = proxmox_api_url || s.proxmox_api_url;
    const tokenId = proxmox_api_token_id || s.proxmox_api_token_id;
    const tokenName = proxmox_api_token_name || s.proxmox_api_token_name;
    const tokenSecret = proxmox_api_token_secret || s.proxmox_api_token_secret;

    if (!node || !ip_address || !apiUrl || !tokenId || !tokenName || !tokenSecret) {
      return res.status(400).json({ message: '❌ Paramètres API ou IP manquants même après fallback.' });
    }

    const client = new ProxmoxService({
      proxmox_api_url: apiUrl,
      proxmox_api_token_id: tokenId,
      proxmox_api_token_name: tokenName,
      proxmox_api_token_secret: tokenSecret,
      proxmox_node: node,
    });

    const vmStatus = await getVMStatus(client, vm_id);
    const pingResult = await isPingable(ip_address);

    await logAction(req, 'check_vm_status', { vm_id, vm_status: vmStatus, ping_ok: pingResult });

    return res.status(200).json({
      message: '✅ État de la VM vérifié',
      vm_status: vmStatus,
      ping_ok: pingResult,
      status_summary:
        vmStatus === 'running'
          ? (pingResult ? '🟢 VM en ligne et accessible' : '🟡 VM allumée mais ne répond pas au ping')
          : '🔴 VM éteinte',
    });
  } catch (error) {
    console.error('❌ Erreur checkVMStatus:', error.message);
    return res.status(500).json({
      message: '❌ Erreur lors de la vérification',
      error: error.message,
    });
  }
};

// 🔄 Convertir une VM en template
exports.convertToTemplate = async (req, res) => {
  const userId = req.user?.id;
  const { vm_id, host: bodyHost, username: bodyUsername, privateKeyPath: bodyKeyPath } = req.body;
  console.log('📥 convertToTemplate called for VM', vm_id);

  if (!vm_id) {
    return res.status(400).json({ message: 'vm_id requis' });
  }

  let host = bodyHost;
  let username = bodyUsername;
  let privateKeyPath = bodyKeyPath;

  try {
    const userSettings = await UserSetting.findOne({ where: { user_id: userId } });

    if (!userSettings) {
      console.log('⚠️ Paramètres utilisateur introuvables');
      return res.status(404).json({ message: 'Paramètres utilisateur introuvables' });
    }

    const s = userSettings.get({ plain: true });

    host = host || s.proxmox_host;
    username = username || s.proxmox_ssh_user;
    privateKeyPath = privateKeyPath || s.ssh_private_key_path;

    if (!host || !username || !privateKeyPath) {
      console.log('⚠️ Informations de connexion manquantes');
      return res.status(400).json({ message: 'host, username ou privateKeyPath manquant' });
    }

    const privateKey = fs.readFileSync(path.resolve(privateKeyPath), 'utf-8');
    const startTime = new Date();
    const logFileName = `convert-template-${startTime.toISOString().replace(/[:.]/g, '-')}-${userId}.log`;
    const logsDir = path.resolve(__dirname, '../../logs');
    if (!fs.existsSync(logsDir)) fs.mkdirSync(logsDir);
    const logPath = path.join(logsDir, logFileName);

    let outputLog = `=== CONVERSION TEMPLATE VM ${vm_id} ===\n📅 Date : ${startTime.toISOString()}\n`;

    const cmds = [
      `qm stop ${vm_id}`,
      `qm set ${vm_id} --ide2 local-lvm:cloudinit`,
      `qm set ${vm_id} --boot order=scsi0`,
      `qm set ${vm_id} --agent enabled=1`,
      `qm template ${vm_id}`
    ];

    for (const cmd of cmds) {
      outputLog += `\n$ ${cmd}\n`;
      const { stdout, stderr } = await execSSHCommand({ host, username, privateKey, command: cmd });
      outputLog += stdout || '';
      if (stderr) outputLog += stderr;
      outputLog += '\n';
    }

    fs.writeFileSync(logPath, outputLog);

    const vm_name = req.body.vm_name || `vm_${vm_id}`;
    await ConvertedVm.create({ vm_name, vm_id, user_id: userId });
    await logAction(req, 'convert_vm_template', { vm_id });

    return res.status(200).json({
      message: `VM ${vm_id} convertie en template Cloud-Init`,
      output: outputLog,
      log: logPath,
    });

  } catch (error) {
    const failTime = new Date();
    const logFileName = `convert-template-${failTime.toISOString().replace(/[:.]/g, '-')}-${userId}.log`;
    const logsDir = path.resolve(__dirname, '../../logs');
    if (!fs.existsSync(logsDir)) fs.mkdirSync(logsDir);
    const logPath = path.join(logsDir, logFileName);

    const errorLog = `=== ECHEC CONVERSION TEMPLATE VM ${vm_id} ===\n📅 Date : ${failTime.toISOString()}\n\nErreur : ${error.message || error}\n`;
    fs.writeFileSync(logPath, errorLog);
    console.error('❌ convertToTemplate error:', error);

    return res.status(500).json({
      message: 'Echec de la conversion en template',
      error: error.message || error,
      log: logPath,
    });
  }
};

// 📜 Historique des conversions
exports.getConversionHistory = async (req, res) => {
  console.log('📥 getConversionHistory called', req.query);
  try {
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;
    const offset = (page - 1) * limit;
    const sort = req.query.sort || 'created_at';
    const direction = req.query.order === 'asc' ? 'ASC' : 'DESC';
    const where = {};
    if (req.query.q) {
      const q = req.query.q;
      where[Op.or] = [
        { vm_name: { [Op.iLike]: `%${q}%` } },
        { '$user.email$': { [Op.iLike]: `%${q}%` } },
      ];
    }
    const { count, rows } = await ConvertedVm.findAndCountAll({
      where,
      include: [{ model: User, as: 'user', attributes: ['id', 'email'] }],
      order: [[sort, direction]],
      limit,
      offset,
    });
    console.log(`📤 ${rows.length} conversions trouvées`);
    await logAction(req, 'view_conversion_history');
    res.json({
      data: rows,
      pagination: {
        total: count,
        page,
        pages: Math.ceil(count / limit),
        limit,
      },
    });
  } catch (err) {
    console.error('❌ Erreur history:', err);
    res.status(500).json({ message: 'Erreur serveur.' });
  }
};

exports.deleteVMDirect = async (req, res) => {
  const user = req.user;
  const {
    vm_id,
    node: bodyNode,
    instance_id,
    proxmox_api_url,
    proxmox_api_token_id,
    proxmox_api_token_name,
    proxmox_api_token_secret,
  } = req.body;

  if (!vm_id || !instance_id) {
    return res.status(400).json({
      message: "❌ Champs requis : vm_id et instance_id",
    });
  }

  const settings = await UserSetting.findOne({ where: { user_id: user.id } });

  const s = settings?.get({ plain: true }) || {};
  const node = bodyNode || s.proxmox_node;
  const apiUrl = proxmox_api_url || s.proxmox_api_url;
  const tokenId = proxmox_api_token_id || s.proxmox_api_token_id;
  const tokenName = proxmox_api_token_name || s.proxmox_api_token_name;
  const tokenSecret = proxmox_api_token_secret || s.proxmox_api_token_secret;

  if (!node || !apiUrl || !tokenId || !tokenName || !tokenSecret) {
    return res.status(400).json({
      message: "❌ Informations Proxmox incomplètes (node, url, token id, nom ou secret)",
    });
  }

  console.log(`🧨 Suppression VM ${vm_id} (instance ${instance_id}) déclenchée par ${user.email}`);
  console.log("🔧 Paramètres utilisés :");
  console.log("- node           :", node);
  console.log("- apiUrl         :", apiUrl);
  console.log("- tokenId        :", tokenId);
  console.log("- tokenName      :", tokenName);
  console.log("- tokenSecret... :", tokenSecret?.slice(0, 8) + "...");

  const startTime = new Date();
  let success = false;
  let logOutput = "";

  let vm_name = `vm-${vm_id}`;
  let vm_ip = null;

  try {
    const client = new ProxmoxService({
      proxmox_api_url: apiUrl,
      proxmox_api_token_id: tokenId,
      proxmox_api_token_name: tokenName,
      proxmox_api_token_secret: tokenSecret,
      proxmox_node: node,
    });

    const vmInfo = await getVMInfo(client, vm_id);
    if (!vmInfo || !vmInfo.name) {
      return res.status(404).json({
        message: `❌ La VM ${vm_id} n'existe pas sur ${node}.`,
      });
    }

    vm_name = vmInfo.name;
    vm_ip = await getVMIP(client, vm_id);

    const status = await getVMStatus(client, vm_id);
    logOutput += `Statut initial: ${status}\n`;

    if (status === "running") {
      await client.post(`/nodes/${client.node}/qemu/${vm_id}/status/stop`);
      logOutput += `🛑 Arrêt demandé...\n`;

      let attempts = 0;
      const maxAttempts = 5;
      while (attempts < maxAttempts) {
        await new Promise((r) => setTimeout(r, 2000));
        const currentStatus = await getVMStatus(client, vm_id);
        logOutput += `⏳ Tentative ${attempts + 1}: statut = ${currentStatus}\n`;
        if (currentStatus !== "running") break;
        attempts++;
      }

      const finalStatus = await getVMStatus(client, vm_id);
      if (finalStatus === "running") {
        return res.status(500).json({
          message: "❌ La VM est toujours active après plusieurs tentatives d'arrêt.",
        });
      }
    }

    logOutput += `✅ VM arrêtée. Suppression en cours...\n`;
    const result = await deleteVM(client, vm_id);
    success = true;

    const endTime = new Date();
    const logFilename = `delete-${startTime.toISOString().replace(/[:.]/g, "-")}-${user.id}.log`;
    const logsDir = path.resolve(__dirname, "../../logs");
    if (!fs.existsSync(logsDir)) fs.mkdirSync(logsDir);
    const logPath = path.join(logsDir, logFilename);
    fs.writeFileSync(logPath, logOutput);

    await Deployment.update(
      { operation_type: "destroy" },
      { where: { vm_id, instance_id } }
    );

    await Delete.create({
      vm_id,
      instance_id,
      vm_name,
      vm_ip,
      log_path: logPath,
      user_id: user.id,
      user_email: user.email,
      deleted_at: new Date(),
    });

    return res.status(200).json({
      message: "✅ VM arrêtée et supprimée avec succès",
      result,
      log: logPath,
    });
  } catch (error) {
    console.error("❌ Erreur suppression VM :", error.message);

    const logFilename = `delete-${startTime.toISOString().replace(/[:.]/g, "-")}-${user.id}.log`;
    const logPath = path.join(__dirname, "../../logs", logFilename);
    fs.writeFileSync(logPath, logOutput + `\nErreur : ${error.message}`);

    await Deployment.update(
      { operation_type: "destroy" },
      { where: { vm_id, instance_id } }
    );

    await Delete.create({
      vm_id,
      instance_id,
      vm_name,
      vm_ip,
      log_path: logPath,
      user_id: user.id,
      user_email: user.email,
      deleted_at: new Date(),
    });

    return res.status(500).json({
      message: "❌ Échec de la suppression de la VM",
      error: error.message,
    });
  }
};

exports.checkIfVMNameExists = async (settings, vmNameToCheck) => {
  const resolved = {
    proxmox_api_url: settings.proxmox_api_url || settings.apiUrl,
    proxmox_api_token_id: settings.proxmox_api_token_id || settings.tokenId,
    proxmox_api_token_name: settings.proxmox_api_token_name || settings.tokenName,
    proxmox_api_token_secret: settings.proxmox_api_token_secret || settings.tokenSecret,
    proxmox_node: settings.proxmox_node || settings.node,
  };

  const client = new ProxmoxService(resolved);
  try {
    const rows = await client.get('/cluster/resources?type=vm');
    const allVMs = (Array.isArray(rows) ? rows : []).filter(r => r.type === 'qemu');
    return !!allVMs.find(vm => vm.name === vmNameToCheck);
  } catch (error) {
    console.error('❌ [checkIfVMNameExists] Erreur :', error.message);
    return false;
  }
};
