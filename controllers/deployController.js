const fs = require("fs");
const path = require("path");
const { runTerraformApply } = require("../utils/terraformRunner");
const { runTerraformDestroy } = require("../utils/terraformRunner");
const { Deployment, ServiceConfiguration, InitScript } = require("../models");

exports.deployInfrastructure = async (req, res) => {
  const user = req.user;

  try {
    console.log("📨 [API] Requête de déploiement reçue par :", user.email);

    const payload = req.body;
    const vmName = payload.vm_names[0];
    const service_name = vmName;
    const startTime = new Date();

    console.log("🔍 [API] Service demandé :", service_name);

    // 1️⃣ Récupérer le script dynamique de configuration
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

    // 2️⃣ Récupérer le script d'initialisation manuellement choisi
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

    // 3️⃣ Injecter les chemins dans le payload
    payload.config_scriptconfig_script = configScriptPath;
    payload.init_script = initScriptPath || ""; // vide si non fourni
    payload.service_config_scripts = {
      [service_name]: configScriptPath,
    };

    console.log("🧩 [API] Scripts injectés :\n- config:", configScriptPath, "\n- init:", initScriptPath);

    // 4️⃣ Lancer Terraform
    console.log("🚀 [API] Lancement de runTerraformApply...");
    const { stdout, stderr, success } = await runTerraformApply(payload);
    const endTime = new Date();
    const duration = (endTime - startTime) / 1000;

    // 5️⃣ Log dans fichier
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

    // 6️⃣ Enregistrement en base
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
    });

    res.status(200).json({
      message: "✅ Déploiement réussi",
      output: stdout,
      log: logPath,
    });

  } catch (error) {
    console.error("❌ Erreur de déploiement:", error);
    res.status(500).json({
      message: "❌ Échec du déploiement",
      error: error.message,
    });
  }
};

exports.destroyInfrastructure = async (req, res) => {
  const user = req.user;

  try {
    console.log("📨 [API] Requête de destruction reçue par :", user.email);

    const startTime = new Date();

    // 🔥 Lancement du destroy
    const { stdout, stderr, success } = await runTerraformDestroy();
    const endTime = new Date();
    const duration = (endTime - startTime) / 1000;

    // 🗂️ Log fichier
    const logFilename = `destroy-${startTime.toISOString().replace(/[:.]/g, "-")}-${user.id}.log`;
    const logPath = path.join(__dirname, "..", "logs", logFilename);
    const logContent =
      `==== DESTRUCTION PAR ${user.email} ====\n\n` +
      `📅 Début : ${startTime.toISOString()}\n` +
      `🕒 Durée : ${duration}s\n` +
      `✅ Succès : ${success}\n\n` +
      `--- STDOUT ---\n${stdout}\n\n` +
      `--- STDERR ---\n${stderr}`;

    fs.writeFileSync(logPath, logContent);
    console.log("🗂️ [API] Log destruction écrit :", logPath);

    // 📦 Log en base
    await Deployment.create({
      user_id: user.id,
      user_email: user.email,
      vm_name: null,
      service_name: null,
      operation_type: "destroy",
      started_at: startTime,
      ended_at: endTime,
      duration: `${duration}s`,
      success,
      log_path: logPath,
    });

    res.status(200).json({
      message: "✅ Destruction réussie",
      output: stdout,
      log: logPath,
    });

  } catch (error) {
    console.error("❌ Erreur de destruction:", error);
    res.status(500).json({
      message: "❌ Échec de la destruction",
      error: error.message,
    });
  }
};