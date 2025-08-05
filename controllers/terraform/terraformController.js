const fs = require('fs');
const path = require('path');
const { v4: uuidv4 } = require('uuid');
const { ServiceTemplate, InitializationScript, MonitoringScript, MonitoredService, UserSetting, Deployment } = require('../../models');
const { checkIfVMNameExists } = require('../proxmox/proxmoxController');
const { runTerraformApply } = require('../../utils/terraformRunner');
const { logAction } = require('../../middlewares/log');

exports.deploy = async (req, res) => {
  const user = req.user;
  console.log('📨 [API] Requête de déploiement reçue par :', user.email);

  const payload = { ...req.body };
  const vmName = payload.vm_names && payload.vm_names[0];
  const service_type = payload.service_type;
  let zone = payload.zone || 'LAN';

  if (!service_type) {
    return res.status(400).json({ message: "❌ Champ 'service_type' requis pour charger la configuration" });
  }
  if (!['LAN', 'DMZ', 'WAN'].includes(zone)) {
    return res.status(400).json({ message: "❌ Champ 'zone' invalide (LAN, DMZ ou WAN)" });
  }

  try {
    const startTime = new Date();
    const instanceId = uuidv4();
    const service_name = service_type;

    const userSettings = await UserSetting.findOne({ where: { user_id: user.id } });
    if (!userSettings) {
      return res.status(400).json({ message: '⚠️ Aucun paramètre global défini pour cet utilisateur. Configurez-les d’abord via /api/settings.' });
    }

    payload.cloudinit_user = payload.cloudinit_user || userSettings.cloudinit_user;
    payload.cloudinit_password = payload.cloudinit_password || userSettings.cloudinit_password;
    payload.proxmox_api_url = payload.proxmox_api_url || userSettings.proxmox_api_url;
    payload.proxmox_api_token_id = payload.proxmox_api_token_id || userSettings.proxmox_api_token_id;
    payload.proxmox_api_token_name = payload.proxmox_api_token_name || userSettings.proxmox_api_token_name;
    payload.proxmox_api_token_secret = payload.proxmox_api_token_secret || userSettings.proxmox_api_token_secret;
    payload.pm_user = payload.pm_user || userSettings.pm_user;
    payload.pm_password = payload.pm_password || userSettings.pm_password;
    payload.proxmox_node = payload.proxmox_node || userSettings.proxmox_node;
    payload.vm_storage = payload.vm_storage || userSettings.vm_storage;
    payload.vm_bridge = payload.vm_bridge || userSettings.vm_bridge;
    payload.ssh_public_key_path = payload.ssh_public_key_path || userSettings.ssh_public_key_path;
    payload.ssh_private_key_path = payload.ssh_private_key_path || userSettings.ssh_private_key_path;

    const proxmoxCreds = {
      apiUrl: payload.proxmox_api_url,
      tokenId: payload.proxmox_api_token_id,
      tokenName: payload.proxmox_api_token_name,
      tokenSecret: payload.proxmox_api_token_secret,
    };

    console.log('🔑 [Proxmox Auth] Utilisation de ces identifiants :');
    console.log('   📡 apiUrl      :', proxmoxCreds.apiUrl);
    console.log('   🔐 tokenId     :', proxmoxCreds.tokenId);
    console.log('   🆔 tokenName   :', proxmoxCreds.tokenName);
    console.log('   🔑 tokenSecret :', proxmoxCreds.tokenSecret);

    const nameAlreadyExists = await checkIfVMNameExists(proxmoxCreds, vmName);
    if (nameAlreadyExists) {
      return res.status(400).json({ message: `❌ Le nom de VM '${vmName}' existe déjà.` });
    }

    const scriptModels = {
      config: ServiceTemplate,
      init: InitializationScript,
      monitoring: MonitoringScript,
      services: MonitoredService,
    };

    const scriptRefs = Array.isArray(payload.script_refs)
      ? payload.script_refs
      : [
          { type: 'init', id: payload.initialization_script_id },
          { type: 'config', id: payload.config_id },
          { type: 'monitoring', id: payload.monitoring_script_id },
          { type: 'services', id: payload.monitored_services_script_id },
        ];

    const scriptList = [];
    for (const ref of scriptRefs) {
      if (!ref) continue;
      const { type, id } = ref;
      const Model = scriptModels[type];
      if (!Model) continue;

      let record;
      if (id) {
        record = await Model.findByPk(id);
      } else {
        const where = type === 'config' ? { service_type } : {};
        record = await Model.findOne({ where, order: [['created_at', 'DESC']] });
      }

      if (!record) {
        return res.status(404).json({ message: `Script '${type}' introuvable` });
      }

      scriptList.push(record.script_path.replace(/\\/g, '/'));
    }

    payload.instance_id = instanceId;
    payload.scripts = { [vmName]: scriptList };

    console.log('🧩 Scripts injectés :', scriptList);

    console.log('🚀 Lancement Terraform...');
    const { stdout, stderr, success, vmInfo } = await runTerraformApply(instanceId, payload);
    const endTime = new Date();
    const duration = (endTime - startTime) / 1000;

    const logFilename = `deploy-${startTime.toISOString().replace(/[:.]/g, '-')}-${user.id}.log`;
    const logsDir = path.resolve(__dirname, '../../logs');
    if (!fs.existsSync(logsDir)) fs.mkdirSync(logsDir);
    const logPath = path.resolve(logsDir, logFilename);
    fs.writeFileSync(logPath, `==== DEPLOIEMENT ${service_name} ====\n\n📅 Début : ${startTime}\n🕒 Durée : ${duration}s\n✅ Succès : ${success}\n\n--- STDOUT ---\n${stdout}\n\n--- STDERR ---\n${stderr}`);

    const injectedFiles = scriptList;
    const vmSpecs = {
      template_name: payload.template_name || 'ubuntu-template',
      memory_mb: payload.memory_mb || 2048,
      vcpu_cores: payload.vcpu_cores || 2,
      vcpu_sockets: payload.vcpu_sockets || 1,
      disk_size: payload.disk_size || '20G'
    };

    await Deployment.create({
      user_id: user.id,
      user_email: user.email,
      vm_name: vmName,
      service_name,
      zone,
      operation_type: 'apply',
      started_at: startTime,
      ended_at: endTime,
      duration: `${duration}s`,
      success,
      log_path: logPath,
      vm_id: vmInfo?.vm_ids?.[vmName] || null,
      vm_ip: vmInfo?.vm_ips?.[vmName] || null,
      instance_id: instanceId,
      injected_files: injectedFiles,
      vm_specs: vmSpecs,
      status: 'deployed'
    });

    await logAction(req, 'Déploiement Terraform', { vm_name: vmName, service_type, success });

    res.status(200).json({
      message: '✅ Déploiement réussi',
      output: stdout,
      log: logPath,
      vm_ips: vmInfo?.vm_ips || {},
      vm_names: vmInfo?.vm_names || [],
      ssh_commands: vmInfo?.ssh_commands || {},
      vm_ids: vmInfo?.vm_ids || {},
    });
  } catch (error) {
    console.error('❌ Erreur :', error);
    await logAction(req, 'Échec Déploiement Terraform', { error: error.message });
    res.status(500).json({ message: '❌ Échec du déploiement', error: error.message });
  }
};
