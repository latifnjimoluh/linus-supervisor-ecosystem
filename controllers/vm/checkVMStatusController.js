const axios = require("axios");
const https = require("https");
const ping = require("ping");
const { UserSetting } = require("../../models");

const httpsAgent = new https.Agent({ rejectUnauthorized: false });

function getHeaders(tokenId, tokenName, tokenSecret) {
  return {
    Authorization: `PVEAPIToken=${tokenId}!${tokenName}=${tokenSecret}`,
  };
}

async function getVMStatus({ vmId, node, apiUrl, tokenId, tokenName, tokenSecret }) {
  const url = `${apiUrl}/nodes/${node}/qemu/${vmId}/status/current`;
  const headers = getHeaders(tokenId, tokenName, tokenSecret);

  try {
    const res = await axios.get(url, { httpsAgent, headers });
    return res.data.data.status; // ex: "running", "stopped"
  } catch (err) {
    console.error("❌ Erreur getVMStatus :", err.message);
    throw err;
  }
}

async function isPingable(ip) {
  try {
    const result = await ping.promise.probe(ip);
    return result.alive;
  } catch (err) {
    console.error("❌ Erreur ping :", err.message);
    return false;
  }
}

exports.checkVMStatus = async (req, res) => {
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
    return res.status(400).json({ message: "❌ vm_id requis" });
  }

  try {
    const settings = await UserSetting.findOne({ where: { user_id: userId } });

    if (!settings) {
      return res.status(404).json({ message: "❌ Paramètres utilisateur introuvables" });
    }

    const node = bodyNode || settings.proxmox_node;
    const ip_address = bodyIP || settings.last_used_ip || null;
    const apiUrl = proxmox_api_url || settings.proxmox_api_url;
    const tokenId = proxmox_api_token_id || settings.proxmox_api_token_id;
    const tokenName = proxmox_api_token_name || settings.proxmox_api_token_name;
    const tokenSecret = proxmox_api_token_secret || settings.proxmox_api_token_secret;

    if (!node || !ip_address || !apiUrl || !tokenId || !tokenName || !tokenSecret) {
      return res.status(400).json({ message: "❌ Paramètres API ou IP manquants même après fallback." });
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

    return res.status(200).json({
      message: "✅ État de la VM vérifié",
      vm_status: vmStatus,
      ping_ok: pingResult,
      status_summary: vmStatus === "running"
        ? (pingResult ? "🟢 VM en ligne et accessible" : "🟡 VM allumée mais ne répond pas au ping")
        : "🔴 VM éteinte",
    });

  } catch (error) {
    console.error("❌ Erreur checkVMStatus:", error.message);
    return res.status(500).json({
      message: "❌ Erreur lors de la vérification",
      error: error.message,
    });
  }
};
