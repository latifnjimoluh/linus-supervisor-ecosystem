"use strict";

const fs = require("fs");
const { getRemoteJSON } = require("../../utils/sshClient");
const { SupervisionStatus, ServiceStatus } = require("../../models");
const path = require("path");

exports.fetchFromDynamicVM = async (req, res) => {
  try {
    const { host, username, privateKeyPath, type } = req.body;

    if (!host || !username || !privateKeyPath || !type) {
      return res.status(400).json({
        message: "Champs requis : host, username, privateKeyPath, type (status/services)."
      });
    }

    if (!["status", "services"].includes(type)) {
      return res.status(400).json({ message: "Type invalide. Utiliser status ou services." });
    }

    const filePath = type === "status"
      ? "/tmp/status.json"
      : "/tmp/services_status.json";

    const privateKey = fs.readFileSync(path.resolve(privateKeyPath));

    const jsonData = await getRemoteJSON({
      host,
      username,
      privateKey,
      filePath
    });

    if (type === "status") {
      const record = await SupervisionStatus.create({
        hostname: jsonData.hostname,
        timestamp: jsonData.timestamp,
        bind9_status: jsonData.bind9_status,
        port_53: jsonData.port_53,
        named_checkconf: jsonData.named_checkconf,
        zone_check: jsonData.zone_check,
        dig_test_local: jsonData.dig_test_local,
        open_ports: jsonData.open_ports,
        scan_duration_seconds: jsonData.scan_duration_seconds,
        cpu_load: jsonData.cpu_load,
        ram_usage: jsonData.ram_usage,
        disk_usage: jsonData.disk_usage,
      });

      return res.status(201).json({ message: "✅ Status importé", id: record.id });
    } else {
      const services = jsonData.services || [];

      const inserted = await Promise.all(
        services.map(s => ServiceStatus.create({
          hostname: jsonData.hostname,
          timestamp: jsonData.timestamp,
          name: s.name,
          enabled: s.enabled,
          active: s.active,
        }))
      );

      return res.status(201).json({ message: `✅ ${inserted.length} services importés.` });
    }

  } catch (err) {
    console.error("❌ Erreur SSH dynamique:", err);
    return res.status(500).json({ message: "Erreur SSH ou parsing", error: err.message });
  }
};
