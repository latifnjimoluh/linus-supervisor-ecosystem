// utils/proxmoxService.js
const axios = require("axios");
const https = require("https");

const httpsAgent = new https.Agent({ rejectUnauthorized: false });

// ⚙️ Utilitaire commun d'en-têtes
function getHeaders(tokenId, tokenName, tokenSecret) {
  return {
    Authorization: `PVEAPIToken=${tokenId}!${tokenName}=${tokenSecret}`,
  };
}

// 🔍 Vérifie l'état d'une VM (running / stopped)
exports.getVMStatus = async ({ vmId, node, apiUrl, tokenId, tokenName, tokenSecret }) => {
  const httpsAgent = new https.Agent({ rejectUnauthorized: false });

  const url = `${apiUrl}/nodes/${node}/qemu/${vmId}/status/current`;

  const headers = {
    Authorization: `PVEAPIToken=${tokenId}!${tokenName}=${tokenSecret}`,
  };

  try {
    const res = await axios.get(url, { httpsAgent, headers });
    return res.data?.data?.qmpstatus || "unknown";
  } catch (error) {
    const message = error.response?.data?.message || error.message;
    throw new Error(`Erreur récupération statut VM : ${message}`);
  }
};


// ⏹️ Arrête la VM si elle est en cours d’exécution
exports.stopVM = async ({ vmId, node, apiUrl, tokenId, tokenName, tokenSecret }) => {
  const httpsAgent = new https.Agent({ rejectUnauthorized: false });

  const url = `${apiUrl}/nodes/${node}/qemu/${vmId}/status/stop`;

  const headers = {
    Authorization: `PVEAPIToken=${tokenId}!${tokenName}=${tokenSecret}`,
  };

  try {
    const res = await axios.post(url, null, { httpsAgent, headers });
    console.log("🛑 Arrêt de la VM demandé :", res.data);
    return res.data;
  } catch (error) {
    const message = error.response?.data?.message || error.message;
    throw new Error(`Erreur arrêt VM : ${message}`);
  }
};

// 🗑️ Supprime la VM
exports.deleteVM = async ({ vmId, node, apiUrl, tokenId, tokenName, tokenSecret }) => {
  const headers = getHeaders(tokenId, tokenName, tokenSecret);
  const fullUrl = `${apiUrl}/nodes/${node}/qemu/${vmId}?purge=1&destroy-unreferenced-disks=1`;

  console.log(`🗑️ Suppression de la VM ${vmId} sur le noeud ${node} via : ${fullUrl}`);
  console.log("🔑 En-têtes d'authentification Proxmox :", headers);

  const response = await axios.delete(fullUrl, { httpsAgent, headers });
  console.log("✅ Suppression réussie :", response.data);
  return response.data;
};
