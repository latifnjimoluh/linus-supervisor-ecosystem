const fs = require("fs");
const path = require("path");
const { getVMStatus, stopVM, deleteVM, getVMInfo, getVMIP } = require("../../utils/proxmoxService");
const { Deployment, Delete } = require("../../models");

exports.deleteVMDirect = async (req, res) => {
  const user = req.user;

  const {
    vm_id,
    node,
    instance_id,
    proxmox_api_url,
    proxmox_api_token_id,
    proxmox_api_token_name,
    proxmox_api_token_secret,
  } = req.body;

  console.log(`🧨 Suppression de la VM ID ${vm_id} (instance: ${instance_id}) par ${user.email}...`);

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

  let vm_name = `vm-${vm_id}`;
  let vm_ip = null;

  try {
    const status = await getVMStatus(commonArgs);
    logOutput += `Statut initial: ${status}\n`;

    const vmInfo = await getVMInfo(commonArgs);
    vm_name = vmInfo.name;
    vm_ip = await getVMIP(commonArgs);

    if (status === "running") {
      await stopVM(commonArgs);
      logOutput += `Arrêt demandé...\n`;

      // 🔁 Attendre l'arrêt
      let attempts = 0;
      const maxAttempts = 5;
      while (attempts < maxAttempts) {
        await new Promise((resolve) => setTimeout(resolve, 2000));
        const currentStatus = await getVMStatus(commonArgs);
        logOutput += `Tentative ${attempts + 1}: statut = ${currentStatus}\n`;
        if (currentStatus !== "running") break;
        attempts++;
      }

      const finalStatus = await getVMStatus(commonArgs);
      if (finalStatus === "running") {
        return res.status(500).json({
          message: "❌ La VM est toujours en cours d'exécution, suppression impossible.",
        });
      }
    }

    logOutput += `✅ VM arrêtée. Suppression en cours...\n`;

    const result = await deleteVM(commonArgs);
    success = true;

    const endTime = new Date();
    const duration = (endTime - startTime) / 1000;
    const logFilename = `delete-${startTime.toISOString().replace(/[:.]/g, "-")}-${user.id}.log`;
    const logsDir = path.resolve(__dirname, "../../logs");
    if (!fs.existsSync(logsDir)) fs.mkdirSync(logsDir);
    const logPath = path.join(logsDir, logFilename);
    fs.writeFileSync(logPath, logOutput);

    // 📌 MAJ Déploiement
    await Deployment.update(
      { operation_type: "destroy" },
      {
        where: {
          vm_id,
          instance_id: instance_id || null,
        },
      }
    );

    // 🗑️ Ajout dans Delete
    await Delete.create({
      vm_id,
      instance_id: instance_id || null,
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

    const endTime = new Date();
    const duration = (endTime - startTime) / 1000;
    const logFilename = `delete-${startTime.toISOString().replace(/[:.]/g, "-")}-${user.id}.log`;
    const logPath = path.join(__dirname, "../../logs", logFilename);
    fs.writeFileSync(logPath, logOutput + `\nErreur : ${error.message}`);

    // Sauvegarde partielle malgré l’échec
    await Deployment.update(
      { operation_type: "destroy" },
      {
        where: {
          vm_id,
          instance_id: instance_id || null,
        },
      }
    );

    await Delete.create({
      vm_id,
      instance_id: instance_id || null,
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
