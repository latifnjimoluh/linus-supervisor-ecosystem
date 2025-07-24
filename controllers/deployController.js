const fs = require("fs");
const path = require("path");
const { runTerraformApply } = require("../utils/terraformRunner");
const { runTerraformDestroy } = require("../utils/terraformRunner");
const Deployment = require("../models").Deployment;
const ServiceConfiguration = require("../models").ServiceConfiguration;

exports.deployInfrastructure = async (req, res) => {
  const user = req.user;

  try {
    console.log("📨 [API] Requête de déploiement reçue par :", user.email);

    const payload = req.body;
    const vmName = payload.vm_names[0];
    const service_name = vmName;
    const startTime = new Date();

    console.log("🔍 [API] Service demandé :", service_name);

    // 1️⃣ Récupérer la config dynamique la plus récente
    const serviceConfig = await ServiceConfiguration.findOne({
      where: { service_type: service_name },
      order: [["created_at", "DESC"]],
    });

    console.log("📦 [API] Résultat de ServiceConfiguration :", serviceConfig);

    if (!serviceConfig) {
      return res.status(404).json({
        message: `Aucune configuration dynamique trouvée pour le service '${service_name}'`,
      });
    }

    // 2️⃣ Injecter les chemins correctement formatés
    const configScriptPath = serviceConfig.script_path.replace(/\\/g, "/");

    payload.dns_config_script = configScriptPath;
    payload.dns_init_script = "Scripts/dns-install.sh";

    // 💡 Important : compatibilité avec variables.tf
    payload.service_config_scripts = {
      [service_name]: configScriptPath,
    };

    console.log("🧩 [API] Script injecté dans variables : ", configScriptPath);

    // 3️⃣ Lancer Terraform
    console.log("🚀 [API] Lancement de runTerraformApply...");
    const { stdout, stderr, success } = await runTerraformApply(payload);
    const endTime = new Date();
    const duration = (endTime - startTime) / 1000;

    // 4️⃣ Log dans fichier
    const logFilename = `deploy-${startTime.toISOString().replace(/[:.]/g, "-")}-${user.id}.log`;
    const logPath = path.join(__dirname, "..", "logs", logFilename);
    const logContent = `==== DEPLOIEMENT ${service_name.toUpperCase()} PAR ${user.email} ====\n\n` +
      `📅 Début : ${startTime.toISOString()}\n` +
      `🕒 Durée : ${duration}s\n` +
      `✅ Succès : ${success}\n\n` +
      `--- STDOUT ---\n${stdout}\n\n` +
      `--- STDERR ---\n${stderr}`;

    fs.writeFileSync(logPath, logContent);
    console.log("🗂️ [API] Log écrit :", logPath);

    // 5️⃣ Enregistrer dans la base
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
    const payload = req.body;
    const vmName = payload.vm_names[0];
    const service_name = vmName;
    const startTime = new Date();

    console.log("🧨 [API] Destruction demandée pour :", service_name);

    const { stdout, stderr, success } = await runTerraformDestroy(payload);
    const endTime = new Date();
    const duration = (endTime - startTime) / 1000;

    const logFilename = `destroy-${startTime.toISOString().replace(/[:.]/g, "-")}-${user.id}.log`;
    const logPath = path.join(__dirname, "..", "logs", logFilename);
    const logContent = `==== DESTRUCTION ${service_name.toUpperCase()} PAR ${user.email} ====\n\n` +
      `📅 Début : ${startTime.toISOString()}\n` +
      `🕒 Durée : ${duration}s\n` +
      `✅ Succès : ${success}\n\n` +
      `--- STDOUT ---\n${stdout}\n\n` +
      `--- STDERR ---\n${stderr}`;

    fs.writeFileSync(logPath, logContent);

    await Deployment.create({
      user_id: user.id,
      user_email: user.email,
      vm_name: vmName,
      service_name,
      operation_type: "destroy",
      started_at: startTime,
      ended_at: endTime,
      duration: `${duration}s`,
      success,
      log_path: logPath,
    });

    return res.status(200).json({
      message: "✅ Destruction réussie",
      output: stdout,
      log: logPath,
    });

  } catch (error) {
    console.error("❌ Erreur de destruction:", error);
    return res.status(500).json({
      message: "❌ Échec de la destruction",
      error: error.message,
    });
  }
};
