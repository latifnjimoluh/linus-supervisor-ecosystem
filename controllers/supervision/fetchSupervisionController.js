"use strict";

const fs = require("fs");
const path = require("path");
const { getRemoteJSON, getRemoteFileContent } = require("../../utils/sshClient");
const { StatusSnapshot, ServiceStatus, VMInstance } = require("../../models");
require("dotenv").config();

exports.fetchFromDynamicVM = async (req, res) => {
  try {
    const {
      host,
      username,
      privateKeyPath,
      statusPath: bodyStatusPath,
      servicesPath: bodyServicesPath,
      instanceInfoPath: bodyInstanceInfoPath
    } = req.body;

    if (!host || !username || !privateKeyPath) {
      return res.status(400).json({
        message: "Champs requis : host, username, privateKeyPath."
      });
    }

    const privateKey = fs.readFileSync(path.resolve(privateKeyPath));

    // 📌 Chemins dynamiques avec fallback .env
    const statusPath = bodyStatusPath || process.env.STATUS_JSON_PATH || "/tmp/status.json";
    const servicesPath = bodyServicesPath || process.env.SERVICES_JSON_PATH || "/tmp/services_status.json";
    const instanceInfoPath = bodyInstanceInfoPath || process.env.INSTANCE_INFO_PATH || "/etc/instance-info.conf";

    // 🔍 Récupérer instance ID
    let instanceId = null;
    try {
      const confContent = await getRemoteFileContent({
        host,
        username,
        privateKey,
        filePath: instanceInfoPath
      });

      const match = confContent.match(/^INSTANCE_ID=(.*)$/m);
      instanceId = match ? match[1].trim() : null;

      if (!instanceId) {
        console.warn("⚠️ Impossible de récupérer l'INSTANCE_ID");
      }
    } catch (e) {
      console.warn("⚠️ Erreur lors de la lecture de instance-info.conf :", e.message);
    }

    // 📦 Récupérer les 2 fichiers JSON
    const [statusJSON, servicesJSON] = await Promise.all([
      getRemoteJSON({ host, username, privateKey, filePath: statusPath }),
      getRemoteJSON({ host, username, privateKey, filePath: servicesPath })
    ]);

    const { hostname, timestamp, ...statusData } = statusJSON;

    // ✅ Formater status
    const formatted_status = Object.entries(statusData).map(([key, value]) => ({
      label: key,
      value: value
    }));

    // 💾 Enregistrer status
    await StatusSnapshot.create({
      hostname,
      timestamp,
      data: statusData,
      formatted_data: formatted_status,
      instance_id: instanceId || null
    });

    // ✅ Formater services
    const services = servicesJSON.services || [];

    const formatted_services = services.map(s => ({
      name: s.name,
      enabled: s.enabled,
      active: s.active
    }));

    // 💾 Enregistrer services
    await ServiceStatus.create({
      hostname: servicesJSON.hostname,
      timestamp: servicesJSON.timestamp,
      formatted_data: formatted_services,
      instance_id: instanceId || null
    });

    // 🧾 Historique VM
    await VMInstance.create({
      instance_id: instanceId || null,
      hostname: hostname || servicesJSON.hostname || "unknown",
      ip_address: host,
      fetched_at: new Date()
    });

    return res.status(201).json({
      message: "✅ Données status et services importées avec historique",
      hostname,
      services_count: services.length
    });

  } catch (err) {
    console.error("❌ Erreur SSH dynamique:", err);
    return res.status(500).json({ message: "Erreur SSH ou parsing", error: err.message });
  }
};
