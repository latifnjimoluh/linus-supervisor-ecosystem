const { startVM } = require("../../utils/proxmoxService");
const { UserSetting } = require("../../models");

exports.startVM = async (req, res) => {
  const userId = req.user?.id;
  const {
    vm_id,
    node: bodyNode,
    proxmox_api_url,
    proxmox_api_token_id,
    proxmox_api_token_name,
    proxmox_api_token_secret,
  } = req.body;

  if (!vm_id) {
    return res.status(400).json({ message: "❌ vm_id requis" });
  }

  const settings = await UserSetting.findOne({ where: { user_id: userId } });
  const node = bodyNode || settings?.proxmox_node;
  const apiUrl = proxmox_api_url || settings?.proxmox_api_url;
  const tokenId = proxmox_api_token_id || settings?.proxmox_api_token_id;
  const tokenName = proxmox_api_token_name || settings?.proxmox_api_token_name;
  const tokenSecret = proxmox_api_token_secret || settings?.proxmox_api_token_secret;

  if (!node || !apiUrl || !tokenId || !tokenName || !tokenSecret) {
    return res.status(400).json({ message: "❌ Informations Proxmox incomplètes" });
  }

  try {
    await startVM({ vmId: vm_id, node, apiUrl, tokenId, tokenName, tokenSecret });
    return res.status(200).json({ message: "✅ Démarrage de la VM demandé" });
  } catch (error) {
    console.error("❌ Erreur démarrage VM:", error.message);
    return res.status(500).json({ message: "❌ Échec du démarrage de la VM", error: error.message });
  }
};
