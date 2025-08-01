const fs = require("fs");
const path = require("path");
const {
  getVMStatus,
  stopVM,
  deleteVM,
  getVMInfo,
  getVMIP,
} = require("../../utils/proxmoxService");
const { Deployment, Delete, UserSetting } = require("../../models");

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
      await stopVM(commonArgs);
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
