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

exports.getVMInfo = async ({ vmId, node, apiUrl, tokenId, tokenName, tokenSecret }) => {
  const url = `${apiUrl}/nodes/${node}/qemu/${vmId}/config`;
  const headers = getHeaders(tokenId, tokenName, tokenSecret);

  try {
    const res = await axios.get(url, { httpsAgent, headers });
    const name = res.data?.data?.name || `vm-${vmId}`;
    return { name };
  } catch (error) {
    throw new Error(`Erreur récupération nom VM : ${error.message}`);
  }
};

exports.getVMIP = async ({ vmId, node, apiUrl, tokenId, tokenName, tokenSecret }) => {
  const url = `${apiUrl}/nodes/${node}/qemu/${vmId}/agent/network-get-interfaces`;
  const headers = getHeaders(tokenId, tokenName, tokenSecret);

  try {
    const res = await axios.get(url, { httpsAgent, headers });

    // ✅ Correction ici : on accède à data.result
    const interfaces = res.data?.data?.result || [];

    for (const iface of interfaces) {
      if (iface?.["ip-addresses"]) {
        const ipObj = iface["ip-addresses"].find(ip =>
          ip?.["ip-address"] &&
          !ip["ip-address"].startsWith("127.") &&
          ip["ip-address"].includes(".")
        );
        if (ipObj) return ipObj["ip-address"];
      }
    }

    return null;
  } catch (error) {
    console.warn("⚠️ Impossible d’obtenir l’IP (QEMU Agent ?) :", error.message);
    return null;
  }
};


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

// ▶️ Démarre la VM
exports.startVM = async ({ vmId, node, apiUrl, tokenId, tokenName, tokenSecret }) => {
  const url = `${apiUrl}/nodes/${node}/qemu/${vmId}/status/start`;
  const headers = getHeaders(tokenId, tokenName, tokenSecret);

  try {
    const res = await axios.post(url, null, { httpsAgent, headers });
    console.log("▶️ Démarrage de la VM demandé :", res.data);
    return res.data;
  } catch (error) {
    const message = error.response?.data?.message || error.message;
    throw new Error(`Erreur démarrage VM : ${message}`);
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

exports.checkIfVMNameExists = async ({ apiUrl, tokenId, tokenName, tokenSecret }, vmNameToCheck) => {
  const headers = getHeaders(tokenId, tokenName, tokenSecret);
  const url = `${apiUrl}/cluster/resources`;

  console.log("🌐 [checkIfVMNameExists] URL Proxmox :", url);
  console.log("🔐 [checkIfVMNameExists] Headers :", headers);

  try {
    const res = await axios.get(url, { httpsAgent, headers });
    const allVMs = res.data?.data?.filter(r => r.type === "qemu") || [];

    const found = allVMs.find(vm => vm.name === vmNameToCheck);
    console.log("📋 [checkIfVMNameExists] Liste des VM :", allVMs.map(v => v.name));
    console.log("🔍 [checkIfVMNameExists] Nom trouvé :", found?.name || "non trouvé");

    return !!found;
  } catch (error) {
    console.error("❌ [checkIfVMNameExists] Erreur Axios :", {
      message: error.message,
      status: error.response?.status,
      data: error.response?.data,
    });
    return false;
  }
};
