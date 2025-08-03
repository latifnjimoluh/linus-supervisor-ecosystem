"use strict";

const fs = require("fs");
const path = require("path");
const { getRemoteJSON, getRemoteFileContent } = require("../../utils/sshClient");
const { StatusSnapshot, ServiceStatus, VMInstance, UserSetting } = require("../../models");
require("dotenv").config();

exports.fetchFromDynamicVM = async (req, res) => {
  try {
    const user = req.user;
    if (!user || !user.id) {
      return res.status(401).json({ message: "❌ Utilisateur non authentifié." });
    }

    const {
      host,                       // requis : IP de la VM cible
      username,                   // requis : utilisateur SSH (root, ubuntu, etc.)
      privateKeyPath: bodyKeyPath,
      statusPath: bodyStatusPath,
      servicesPath: bodyServicesPath,
      instanceInfoPath: bodyInstanceInfoPath
    } = req.body;

    if (!host || !username) {
      return res.status(400).json({ message: "❌ Champs requis : host et username." });
    }

    const userSettings = await UserSetting.findOne({ where: { user_id: user.id } });

    const privateKeyPath = bodyKeyPath || userSettings?.ssh_private_key_path;
    const statusPath = bodyStatusPath || userSettings?.statuspath || process.env.STATUS_JSON_PATH || "/tmp/status.json";
    const servicesPath = bodyServicesPath || userSettings?.servicespath || process.env.SERVICES_JSON_PATH || "/tmp/services_status.json";
    const instanceInfoPath = bodyInstanceInfoPath || userSettings?.instanceinfopath || process.env.INSTANCE_INFO_PATH || "/etc/instance-info.conf";

    if (!privateKeyPath) {
      return res.status(400).json({ message: "❌ Le chemin vers la clé privée SSH est manquant." });
    }

    const privateKey = fs.readFileSync(path.resolve(privateKeyPath), "utf-8");

    console.log("🔐 Connexion SSH avec :");
    console.log("- host :", host);
    console.log("- username :", username);
    console.log("- privateKeyPath :", privateKeyPath);
    console.log("- instanceInfoPath :", instanceInfoPath);

    // 🔍 Lire instance-info.conf
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
        console.warn("⚠️ INSTANCE_ID non trouvé dans instance-info.conf");
      }
    } catch (e) {
      console.warn("⚠️ Erreur lecture instance-info.conf :", e.message);
    }

    // 📦 Télécharger les JSON distants
    const [statusJSON, servicesJSON] = await Promise.all([
      getRemoteJSON({ host, username, privateKey, filePath: statusPath }),
      getRemoteJSON({ host, username, privateKey, filePath: servicesPath })
    ]);

    const { hostname, timestamp, ...statusData } = statusJSON;

    const formatted_status = Object.entries(statusData).map(([key, value]) => ({
      label: key,
      value: value
    }));

    await StatusSnapshot.create({
      hostname,
      timestamp,
      formatted_data: formatted_status,
      instance_id: instanceId || null
    });

    const services = servicesJSON.services || [];
    const formatted_services = services.map(s => ({
      name: s.name,
      enabled: s.enabled,
      active: s.active
    }));

    await ServiceStatus.create({
      hostname: servicesJSON.hostname,
      timestamp: servicesJSON.timestamp,
      formatted_data: formatted_services,
      instance_id: instanceId || null
    });

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


