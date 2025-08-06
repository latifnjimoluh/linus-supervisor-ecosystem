const fs = require('fs');
const path = require('path');
const axios = require('axios');
const https = require('https');
const ping = require('ping');
const { Op } = require('sequelize');
const { UserSetting, ConvertedVm, User, Deployment, Delete } = require('../../models');
const { logAction } = require('../../middlewares/log');
const { execSSHCommand } = require('../../utils/sshClient');

const httpsAgent = new https.Agent({ rejectUnauthorized: false });

// util to build auth headers
function getHeaders(tokenId, tokenName, tokenSecret) {
  return { Authorization: `PVEAPIToken=${tokenId}!${tokenName}=${tokenSecret}` };
}

// 🖥️ Lister toutes les VM depuis Proxmox
exports.listVMs = async (req, res) => {
  console.log('📥 listVMs called for user', req.user?.id);
  try {
    const settings = await UserSetting.findOne({ where: { user_id: req.user.id } });
    if (!settings) {
      console.log('⚠️ Paramètres Proxmox introuvables');
      return res.status(404).json({ message: 'Paramètres Proxmox introuvables.' });
    }

    const url = `${settings.proxmox_api_url}/cluster/resources?type=vm`;
    const headers = getHeaders(settings.proxmox_api_token_id, settings.proxmox_api_token_name, settings.proxmox_api_token_secret);
    const response = await axios.get(url, { httpsAgent, headers });
    const vms = response.data?.data || [];
    console.log(`📤 ${vms.length} VM récupérées`);
    await logAction(req, 'list_vms');
    res.json(vms);
  } catch (err) {
    console.error('❌ Erreur listVMs:', err);
    res.status(500).json({ message: 'Erreur serveur.' });
  }
};

async function startVMRequest({ vmId, node, apiUrl, tokenId, tokenName, tokenSecret }) {
  const url = `${apiUrl}/nodes/${node}/qemu/${vmId}/status/start`;
  const headers = getHeaders(tokenId, tokenName, tokenSecret);
  const res = await axios.post(url, null, { httpsAgent, headers });
  console.log('▶️ startVMRequest response:', res.data);
  return res.data;
}

async function stopVMRequest({ vmId, node, apiUrl, tokenId, tokenName, tokenSecret }) {
  const url = `${apiUrl}/nodes/${node}/qemu/${vmId}/status/stop`;
  const headers = getHeaders(tokenId, tokenName, tokenSecret);
  const res = await axios.post(url, null, { httpsAgent, headers });
  console.log('🛑 stopVMRequest response:', res.data);
  return res.data;
}

// ▶️ Démarrer une VM
exports.startVM = async (req, res) => {
  const vmId = req.params.vmId;
  console.log('📥 startVM called for VM', vmId);
  try {
    const settings = await UserSetting.findOne({ where: { user_id: req.user.id } });
    if (!settings) return res.status(404).json({ message: 'Paramètres Proxmox introuvables.' });

    await startVMRequest({
      vmId,
      node: settings.proxmox_node,
      apiUrl: settings.proxmox_api_url,
      tokenId: settings.proxmox_api_token_id,
      tokenName: settings.proxmox_api_token_name,
      tokenSecret: settings.proxmox_api_token_secret,
    });

    await logAction(req, `start_vm:${vmId}`);
    res.json({ message: `VM ${vmId} démarrée.` });
  } catch (err) {
    console.error('❌ Erreur startVM:', err);
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

    await stopVMRequest({
      vmId,
      node: settings.proxmox_node,
      apiUrl: settings.proxmox_api_url,
      tokenId: settings.proxmox_api_token_id,
      tokenName: settings.proxmox_api_token_name,
      tokenSecret: settings.proxmox_api_token_secret,
    });

    await logAction(req, `stop_vm:${vmId}`);
    res.json({ message: `VM ${vmId} arrêtée.` });
  } catch (err) {
    console.error('❌ Erreur stopVM:', err);
    res.status(500).json({ message: 'Erreur arrêt VM.' });
  }
};

async function getVMStatus({ vmId, node, apiUrl, tokenId, tokenName, tokenSecret }) {
  const url = `${apiUrl}/nodes/${node}/qemu/${vmId}/status/current`;
  const headers = getHeaders(tokenId, tokenName, tokenSecret);

  try {
    const res = await axios.get(url, { httpsAgent, headers });
    return res.data?.data?.status;
  } catch (err) {
    console.error('❌ Erreur getVMStatus :', err.message);
    throw err;
  }
}

async function deleteVM({ vmId, node, apiUrl, tokenId, tokenName, tokenSecret }) {
  const url = `${apiUrl}/nodes/${node}/qemu/${vmId}`;
  const headers = getHeaders(tokenId, tokenName, tokenSecret);
  const res = await axios.delete(url, { httpsAgent, headers });
  return res.data;
}

async function getVMInfo({ vmId, node, apiUrl, tokenId, tokenName, tokenSecret }) {
  const url = `${apiUrl}/nodes/${node}/qemu/${vmId}/config`;
  const headers = getHeaders(tokenId, tokenName, tokenSecret);
  const res = await axios.get(url, { httpsAgent, headers });
  return res.data?.data;
}

async function getVMIP({ vmId, node, apiUrl, tokenId, tokenName, tokenSecret }) {
  const url = `${apiUrl}/nodes/${node}/qemu/${vmId}/agent/network-get-interfaces`;
  const headers = getHeaders(tokenId, tokenName, tokenSecret);
  try {
    const res = await axios.get(url, { httpsAgent, headers });
    const interfaces = res.data?.data?.result || res.data?.data || [];
    for (const iface of interfaces) {
      const addresses = iface["ip-addresses"] || iface["ip_addresses"] || [];
      for (const addr of addresses) {
        const ip = addr["ip-address"] || addr.address;
        if (ip && ip !== "127.0.0.1" && ip.includes('.')) {
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

    const node = bodyNode || settings.proxmox_node;
    const ip_address = bodyIP || settings.last_used_ip || null;
    const apiUrl = proxmox_api_url || settings.proxmox_api_url;
    const tokenId = proxmox_api_token_id || settings.proxmox_api_token_id;
    const tokenName = proxmox_api_token_name || settings.proxmox_api_token_name;
    const tokenSecret = proxmox_api_token_secret || settings.proxmox_api_token_secret;

    if (!node || !ip_address || !apiUrl || !tokenId || !tokenName || !tokenSecret) {
      return res.status(400).json({ message: '❌ Paramètres API ou IP manquants même après fallback.' });
    }

    const vmStatus = await getVMStatus({
      vmId: vm_id,
      node,
      apiUrl,
      tokenId,
      tokenName,
      tokenSecret,
    });

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

    host = host || userSettings.proxmox_host;
    username = username || userSettings.proxmox_ssh_user;
    privateKeyPath = privateKeyPath || userSettings.ssh_private_key_path;

    if (!host || !username || !privateKeyPath) {
      console.log('⚠️ Informations de connexion manquantes');
      return res.status(400).json({ message: 'host, username ou privateKeyPath manquant' });
    }

    const privateKey = fs.readFileSync(path.resolve(privateKeyPath), 'utf-8');
    const startTime = new Date();
    const logFileName = `convert-template-${startTime.toISOString().replace(/[:.]/g, '-')}-${userId}.log`;
    const logsDir = path.resolve(__dirname, '../logs');
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
      const result = await execSSHCommand({ host, username, privateKey, command: cmd });
      outputLog += result + '\n';
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
    const logsDir = path.resolve(__dirname, '../logs');
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

  const node = bodyNode || settings?.proxmox_node;
  const apiUrl = proxmox_api_url || settings?.proxmox_api_url;
  const tokenId = proxmox_api_token_id || settings?.proxmox_api_token_id;
  const tokenName = proxmox_api_token_name || settings?.proxmox_api_token_name;
  const tokenSecret = proxmox_api_token_secret || settings?.proxmox_api_token_secret;

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

  const commonArgs = {
    vmId: vm_id,
    node,
    apiUrl,
    tokenId,
    tokenName,
    tokenSecret,
  };

  const startTime = new Date();
  let success = false;
  let logOutput = "";

  let vm_name = `vm-${vm_id}`;
  let vm_ip = null;

  try {
    const vmInfo = await getVMInfo(commonArgs);
    if (!vmInfo || !vmInfo.name) {
      return res.status(404).json({
        message: `❌ La VM ${vm_id} n'existe pas sur ${node}.`,
      });
    }

    vm_name = vmInfo.name;
    vm_ip = await getVMIP(commonArgs);

    const status = await getVMStatus(commonArgs);
    logOutput += `Statut initial: ${status}\n`;

    if (status === "running") {
      await stopVMRequest(commonArgs);
      logOutput += `🛑 Arrêt demandé...\n`;

      let attempts = 0;
      const maxAttempts = 5;
      while (attempts < maxAttempts) {
        await new Promise((r) => setTimeout(r, 2000));
        const currentStatus = await getVMStatus(commonArgs);
        logOutput += `⏳ Tentative ${attempts + 1}: statut = ${currentStatus}\n`;
        if (currentStatus !== "running") break;
        attempts++;
      }

      const finalStatus = await getVMStatus(commonArgs);
      if (finalStatus === "running") {
        return res.status(500).json({
          message: "❌ La VM est toujours active après plusieurs tentatives d'arrêt.",
        });
      }
    }

    logOutput += `✅ VM arrêtée. Suppression en cours...\n`;

    const result = await deleteVM(commonArgs);
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


exports.checkIfVMNameExists = async ({ apiUrl, tokenId, tokenName, tokenSecret }, vmNameToCheck) => {
  const headers = getHeaders(tokenId, tokenName, tokenSecret);
  const url = `${apiUrl}/cluster/resources`;

  console.log("🌐 [checkIfVMNameExists] URL Proxmox :", url);
  console.log("🔐 [checkIfVMNameExists] Headers :", headers);

  try {
    const res = await axios.get(url, { httpsAgent, headers });
    const allVMs = res.data?.data?.filter(r => r.type === "qemu") || [];

    const found = allVMs.find(vm => vm.name === vmNameToCheck);
    console.log("📋 [checkIfVMNameExists] Liste des VM :", allVMs.map(v => v.name));
    console.log("🔍 [checkIfVMNameExists] Nom trouvé :", found?.name || "non trouvé");

    return !!found;
  } catch (error) {
    console.error("❌ [checkIfVMNameExists] Erreur Axios :", {
      message: error.message,
      status: error.response?.status,
      data: error.response?.data,
    });
    return false;
  }
};
