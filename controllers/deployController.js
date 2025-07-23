const fs = require("fs");
const path = require("path");
const { runTerraformApply } = require("../utils/terraformRunner");
const Deployment = require("../models").Deployment;

exports.deployInfrastructure = async (req, res) => {
  const user = req.user; // récupéré via middleware auth

  try {
    const payload = req.body;
    const vmName = payload.vm_names[0]; // ex: ["dns"]
    const service_name = vmName;        // on suppose 1 VM = 1 service
    const startTime = new Date();

    // Lancer Terraform
    const { stdout, stderr, success } = await runTerraformApply(payload);

    const endTime = new Date();
    const duration = (endTime - startTime) / 1000; // durée en secondes

    // Générer fichier .log
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

    // Enregistrer en base
    await Deployment.create({
      user_id: user.id,
      user_email: user.email,
      vm_name: vmName,
      service_name,
      started_at: startTime,
      ended_at: endTime,
      duration: `${duration}s`,
      success,
      log_path: logPath
    });

    // Réponse HTTP
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

    const { stdout, stderr, success } = await runTerraformDestroy(payload);

    const endTime = new Date();
    const duration = (endTime - startTime) / 1000;

    const logFilename = `destroy-${startTime.toISOString().replace(/[:.]/g, "-")}-${user.id}.log`;
    const logPath = path.join(__dirname, "..", "logs", logFilename);
    const logContent =
      `==== DESTRUCTION ${service_name.toUpperCase()} PAR ${user.email} ====\n\n` +
      `📅 Début : ${startTime.toISOString()}\n` +
      `🕒 Durée : ${duration}s\n` +
      `✅ Succès : ${success}\n\n` +
      `--- STDOUT ---\n${stdout}\n\n` +
      `--- STDERR ---\n${stderr}`;
    fs.writeFileSync(logPath, logContent);

    res.status(200).json({
      message: "🧨 Destruction terminée",
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
