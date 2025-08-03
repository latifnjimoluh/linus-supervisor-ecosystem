const fs = require("fs");
const path = require("path");
const { v4: uuidv4 } = require("uuid");
const { runTerraformApply } = require("../../utils/terraformRunner");
const {
  Deployment,
  ServiceTemplate,
  InitializationScript,
  MonitoringScript,
  MonitoredService,
  UserSetting
} = require("../../models");
const { checkIfVMNameExists } = require("../../utils/proxmoxService");

exports.deployVMDirect = async (req, res) => {
  const user = req.user;

  try {
    console.log("📨 [API] Requête de déploiement reçue par :", user.email);
    const payload = req.body;
    const vmName = payload.vm_names[0];
    const service_type = payload.service_type;
    if (!service_type) {
      return res.status(400).json({ message: "❌ Champ 'service_type' requis pour charger la configuration" });
    }

    const startTime = new Date();
    const instanceId = uuidv4();
    const service_name = service_type;

    // 🔄 Charger les paramètres globaux de l'utilisateur
    const userSettings = await UserSetting.findOne({ where: { user_id: user.id } });
    if (!userSettings) {
      return res.status(400).json({
        message: "⚠️ Aucun paramètre global défini pour cet utilisateur. Configurez-les d’abord via /api/settings."
      });
    }

    // ✅ Appliquer les paramètres globaux si absents du payload
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

    // 🔐 Authentification Proxmox
    const proxmoxCreds = {
      apiUrl: payload.proxmox_api_url,
      tokenId: payload.proxmox_api_token_id,
      tokenName: payload.proxmox_api_token_name,
      tokenSecret: payload.proxmox_api_token_secret,
    };

    console.log("🔑 [Proxmox Auth] Utilisation de ces identifiants :");
    console.log("   📡 apiUrl      :", proxmoxCreds.apiUrl);
    console.log("   🔐 tokenId     :", proxmoxCreds.tokenId);
    console.log("   🆔 tokenName   :", proxmoxCreds.tokenName);
    console.log("   🔑 tokenSecret :", proxmoxCreds.tokenSecret);

    const nameAlreadyExists = await checkIfVMNameExists(proxmoxCreds, vmName);
    if (nameAlreadyExists) {
      return res.status(400).json({ message: `❌ Le nom de VM '${vmName}' existe déjà.` });
    }

    // 1️⃣ CONFIGURATION
    let configScriptPath = "";
    if (payload.config_id) {
      const config = await ServiceTemplate.findByPk(payload.config_id);
      if (!config) return res.status(404).json({ message: `Configuration introuvable (ID: ${payload.config_id})` });
      configScriptPath = config.script_path.replace(/\\/g, "/");
    } else {
      const latestConfig = await ServiceTemplate.findOne({ where: { service_type }, order: [["created_at", "DESC"]] });
      if (!latestConfig) return res.status(404).json({ message: `Aucune configuration trouvée pour '${service_name}'` });
      configScriptPath = latestConfig.script_path.replace(/\\/g, "/");
    }

    // 2️⃣ INITIALIZATION
    let initializationScriptPath = "";
    if (payload.initialization_script_id) {
      const init = await InitializationScript.findByPk(payload.initialization_script_id);
      if (!init) return res.status(404).json({ message: `Script init introuvable (ID: ${payload.initialization_script_id})` });
      initializationScriptPath = init.script_path.replace(/\\/g, "/");
    } else {
      const latestInit = await InitializationScript.findOne({ order: [["created_at", "DESC"]] });
      if (latestInit) initializationScriptPath = latestInit.script_path.replace(/\\/g, "/");
    }

    // 3️⃣ MONITORING
    let monitoringScriptPath = "";
    if (payload.monitoring_script_id) {
      const monitor = await MonitoringScript.findByPk(payload.monitoring_script_id);
      if (!monitor) return res.status(404).json({ message: `Script monitoring introuvable (ID: ${payload.monitoring_script_id})` });
      monitoringScriptPath = monitor.script_path.replace(/\\/g, "/");
    } else {
      const latestMonitor = await MonitoringScript.findOne({ order: [["created_at", "DESC"]] });
      if (latestMonitor) monitoringScriptPath = latestMonitor.script_path.replace(/\\/g, "/");
    }

    // 4️⃣ MONITORED SERVICES
    let monitoredServicesScriptPath = "";
    if (payload.monitored_services_script_id) {
      const monitorServices = await MonitoredService.findByPk(payload.monitored_services_script_id);
      if (!monitorServices) return res.status(404).json({ message: `Script services introuvable (ID: ${payload.monitored_services_script_id})` });
      monitoredServicesScriptPath = monitorServices.script_path.replace(/\\/g, "/");
    } else {
      const latestMonitorService = await MonitoredService.findOne({ order: [["created_at", "DESC"]] });
      if (latestMonitorService) monitoredServicesScriptPath = latestMonitorService.script_path.replace(/\\/g, "/");
    }

    // 5️⃣ Préparation pour Terraform
    payload.instance_id = instanceId;
    payload.initialization_script = initializationScriptPath;
    payload.monitoring_script = monitoringScriptPath;
    payload.monitored_services_script = monitoredServicesScriptPath;
    payload.service_config_scripts = { [vmName]: configScriptPath };

    console.log("🧩 Scripts injectés :", {
      config: configScriptPath,
      initialization: initializationScriptPath,
      monitoring: monitoringScriptPath,
      monitored_services: monitoredServicesScriptPath,
    });

    // 6️⃣ Lancement Terraform
    console.log("🚀 Lancement Terraform...");
    const { stdout, stderr, success, vmInfo } = await runTerraformApply(instanceId, payload);
    const endTime = new Date();
    const duration = (endTime - startTime) / 1000;

    // 7️⃣ Journalisation
    const logFilename = `deploy-${startTime.toISOString().replace(/[:.]/g, "-")}-${user.id}.log`;
    const logsDir = path.resolve(__dirname, "../../logs");
    if (!fs.existsSync(logsDir)) fs.mkdirSync(logsDir);
    const logPath = path.resolve(logsDir, logFilename);
    fs.writeFileSync(logPath, `==== DEPLOIEMENT ${service_name} ====\n\n📅 Début : ${startTime}\n🕒 Durée : ${duration}s\n✅ Succès : ${success}\n\n--- STDOUT ---\n${stdout}\n\n--- STDERR ---\n${stderr}`);

    const injectedFiles = [initializationScriptPath, monitoringScriptPath, monitoredServicesScriptPath, configScriptPath].filter(Boolean);
    const vmSpecs = {
      template_name: payload.template_name || "ubuntu-template",
      memory_mb: payload.memory_mb || 2048,
      vcpu_cores: payload.vcpu_cores || 2,
      vcpu_sockets: payload.vcpu_sockets || 1,
      disk_size: payload.disk_size || "20G"
    };

    await Deployment.create({
      user_id: user.id,
      user_email: user.email,
      vm_name: vmName,
      service_name,
      operation_type: "apply",
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
      status: "deployed"
    });

    res.status(200).json({
      message: "✅ Déploiement réussi",
      output: stdout,
      log: logPath,
      vm_ips: vmInfo?.vm_ips || {},
      vm_names: vmInfo?.vm_names || [],
      ssh_commands: vmInfo?.ssh_commands || {},
      vm_ids: vmInfo?.vm_ids || {},
    });

  } catch (error) {
    console.error("❌ Erreur :", error);
    res.status(500).json({ message: "❌ Échec du déploiement", error: error.message });
  }
};
