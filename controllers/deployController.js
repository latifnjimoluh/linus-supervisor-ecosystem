const fs = require("fs");
const path = require("path");
const { runTerraformApply } = require("../utils/terraformRunner");
const { Deployment, ServiceConfiguration, InitScript } = require("../models");
const { getVMStatus, stopVM, deleteVM, getVMInfo, getVMIP } = require("../utils/proxmoxService");

exports.deployInfrastructure = async (req, res) => {
  const user = req.user;

  try {
    console.log("📨 [API] Requête de déploiement reçue par :", user.email);

    const payload = req.body;
    const vmName = payload.vm_names[0];
    const service_name = vmName;
    const startTime = new Date();

    console.log("🔍 [API] Service demandé :", service_name);

    // 1️⃣ Récupérer la configuration dynamique
    const configId = payload.config_id;
    let serviceConfig;

    if (configId) {
      serviceConfig = await ServiceConfiguration.findByPk(configId);
      if (!serviceConfig) {
        return res.status(404).json({
          message: `Configuration dynamique introuvable pour l'ID '${configId}'`,
        });
      }
      console.log(`📌 [API] Script config sélectionné (ID: ${configId})`);
    } else {
      serviceConfig = await ServiceConfiguration.findOne({
        where: { service_type: service_name },
        order: [["created_at", "DESC"]],
      });
      if (!serviceConfig) {
        return res.status(404).json({
          message: `Aucune configuration dynamique trouvée pour le service '${service_name}'`,
        });
      }
      console.log("🧠 [API] Dernière configuration utilisée automatiquement");
    }

    const configScriptPath = serviceConfig.script_path.replace(/\\/g, "/");

    // 2️⃣ Script d'init si sélectionné
    let initScriptPath = null;
    if (payload.init_script_id) {
      const initScript = await InitScript.findByPk(payload.init_script_id);
      if (!initScript) {
        return res.status(404).json({
          message: `Script d'initialisation introuvable pour l'ID '${payload.init_script_id}'`,
        });
      }
      initScriptPath = initScript.script_path.replace(/\\/g, "/");
      console.log(`📌 [API] Script init sélectionné (ID: ${payload.init_script_id})`);
    }

    // 2️⃣ Bis : Script de monitoring si sélectionné
    let monitoringScriptPath = "";
    if (payload.monitoring_script_id) {
      const monitoringScript = await InitScript.findByPk(payload.monitoring_script_id);
      if (!monitoringScript) {
        return res.status(404).json({
          message: `Script de monitoring introuvable pour l'ID '${payload.monitoring_script_id}'`,
        });
      }
      monitoringScriptPath = monitoringScript.script_path.replace(/\\/g, "/");
      console.log(`🩺 [API] Script de monitoring sélectionné (ID: ${payload.monitoring_script_id})`);
    }

    // 3️⃣ Injecter les chemins dans le payload
    payload.init_script = initScriptPath || "";
    payload.monitoring_script = monitoringScriptPath || "";
    payload.service_config_scripts = {
      [service_name]: configScriptPath,
    };

    console.log("🧩 [API] Scripts injectés :");
    console.log("   🔧 config       :", configScriptPath);
    console.log("   ⚙️  init         :", initScriptPath);
    console.log("   🩺 monitoring   :", monitoringScriptPath);

    // 4️⃣ Exécuter Terraform
    console.log("🚀 [API] Lancement de runTerraformApply...");
    const { stdout, stderr, success, vmInfo } = await runTerraformApply(payload); // vmInfo = outputs
    const endTime = new Date();
    const duration = (endTime - startTime) / 1000;

    // 5️⃣ Créer un log fichier
    const logFilename = `deploy-${startTime.toISOString().replace(/[:.]/g, "-")}-${user.id}.log`;
    const logPath = path.join(__dirname, "..", "logs", logFilename);
    const logContent =
      `==== DEPLOIEMENT ${service_name.toUpperCase()} PAR ${user.email} ====\n\n` +
      `📅 Début : ${startTime.toISOString()}\n` +
      `🕒 Durée : ${duration}s\n` +
      `✅ Succès : ${success}\n\n` +
      `--- STDOUT ---\n${stdout}\n\n` +
      `--- STDERR ---\n${stderr}`;
    fs.writeFileSync(logPath, logContent);
    console.log("🗂️ [API] Log écrit :", logPath);

    // 6️⃣ Enregistrement BD enrichi avec IP & ID de VM
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
    });

    // 7️⃣ Réponse enrichie avec les infos utiles
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
    console.error("❌ Erreur de déploiement:", error);
    res.status(500).json({
      message: "❌ Échec du déploiement",
      error: error.message,
    });
  }
};

exports.deleteVMDirect = async (req, res) => {
  const user = req.user;
  const {
    vm_id,
    node,
    proxmox_api_url,
    proxmox_api_token_id,
    proxmox_api_token_name,
    proxmox_api_token_secret,
  } = req.body;

  console.log(`🧨 Suppression manuelle de la VM ID ${vm_id} par ${user.email}...`);

  const commonArgs = {
    vmId: vm_id,
    node,
    apiUrl: proxmox_api_url,
    tokenId: proxmox_api_token_id,
    tokenName: proxmox_api_token_name,
    tokenSecret: proxmox_api_token_secret,
  };

  const startTime = new Date();
  let success = false;
  let logOutput = "";

  try {
    const status = await getVMStatus(commonArgs);
    console.log(`💡 Statut actuel de la VM ${vm_id} : ${status}`);
    logOutput += `Statut initial: ${status}\n`;

    
    // ✅ Récupérer les infos AVANT la suppression
    const { name: vm_name } = await getVMInfo(commonArgs);
    const vm_ip = await getVMIP(commonArgs);
    console.log("📡 IP récupérée depuis QEMU Agent :", vm_ip);

    if (status === "running") {
      await stopVM(commonArgs);
      logOutput += `Demande d'arrêt envoyée...\n`;

      let attempts = 0;
      const maxAttempts = 5;
      while (attempts < maxAttempts) {
        await new Promise((resolve) => setTimeout(resolve, 2000));
        const newStatus = await getVMStatus(commonArgs);
        logOutput += `Tentative ${attempts + 1}: statut = ${newStatus}\n`;
        if (newStatus !== "running") break;
        attempts++;
      }

      const finalStatus = await getVMStatus(commonArgs);
      if (finalStatus === "running") {
        return res.status(500).json({
          message: "❌ La VM est toujours en cours d'exécution, impossible de supprimer.",
        });
      }
    }

    logOutput += `✅ La VM ${vm_id} est arrêtée, suppression en cours...\n`;

    const result = await deleteVM(commonArgs);
    success = true;

    const endTime = new Date();
    const duration = (endTime - startTime) / 1000;
    const logFilename = `delete-${startTime.toISOString().replace(/[:.]/g, "-")}-${user.id}.log`;
    const logPath = path.join(__dirname, "..", "logs", logFilename);
    fs.writeFileSync(logPath, logOutput);
    console.log("🗂️ [API] Log de suppression écrit :", logPath);

    await Deployment.create({
      user_id: user.id,
      user_email: user.email,
      vm_name,
      service_name: vm_name,
      operation_type: "destroy",
      started_at: startTime,
      ended_at: endTime,
      duration: `${duration}s`,
      success,
      log_path: logPath,
      vm_id: vm_id,
      vm_ip: vm_ip,
    });

    res.status(200).json({
      message: "✅ VM arrêtée et supprimée avec succès",
      result,
      log: logPath,
    });

  } catch (error) {
    console.error("❌ Erreur de suppression directe :", error);

    // ⛑️ Tentative de récupération VM name et IP avant suppression si possible
    let vm_name = `vm-${vm_id}`;
    let vm_ip = null;
    try {
      const info = await getVMInfo(commonArgs);
      vm_name = info.name;
      vm_ip = await getVMIP(commonArgs);
    } catch (_) {}

    const endTime = new Date();
    const duration = (endTime - startTime) / 1000;
    const logFilename = `delete-${startTime.toISOString().replace(/[:.]/g, "-")}-${user.id}.log`;
    const logPath = path.join(__dirname, "..", "logs", logFilename);
    fs.writeFileSync(logPath, logOutput + `\nErreur : ${error.message}`);

    await Deployment.create({
      user_id: user.id,
      user_email: user.email,
      vm_name,
      service_name: vm_name,
      operation_type: "destroy",
      started_at: startTime,
      ended_at: endTime,
      duration: `${duration}s`,
      success: false,
      log_path: logPath,
      vm_id,
      vm_ip,
    });

    res.status(500).json({
      message: "❌ Échec de la suppression manuelle",
      error: error.message,
    });
  }
};