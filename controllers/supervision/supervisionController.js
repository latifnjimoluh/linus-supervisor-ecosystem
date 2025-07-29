// controllers/supervisionController.js
"use strict";

const { SupervisionStatus, ServiceStatus } = require("../../models");

exports.saveStatus = async (req, res) => {
  try {
    const data = req.body;
    if (!data.hostname || !data.timestamp) {
      return res.status(400).json({ message: "Champs hostname et timestamp requis." });
    }

    const record = await SupervisionStatus.create({
      hostname: data.hostname,
      timestamp: data.timestamp,
      bind9_status: data.bind9_status,
      port_53: data.port_53,
      named_checkconf: data.named_checkconf,
      zone_check: data.zone_check,
      dig_test_local: data.dig_test_local,
      open_ports: data.open_ports,
      scan_duration_seconds: data.scan_duration_seconds,
      cpu_load: data.cpu_load,
      ram_usage: data.ram_usage,
      disk_usage: data.disk_usage,
    });

    return res.status(201).json({ message: "Status enregistré.", id: record.id });
  } catch (error) {
    console.error("Erreur enregistrement status:", error);
    return res.status(500).json({ message: "Erreur serveur", error: error.message });
  }
};

exports.saveServices = async (req, res) => {
  try {
    const { hostname, timestamp, services } = req.body;
    if (!hostname || !timestamp || !Array.isArray(services)) {
      return res.status(400).json({ message: "hostname, timestamp et services requis." });
    }

    const records = await Promise.all(
      services.map((s) =>
        ServiceStatus.create({
          hostname,
          timestamp,
          name: s.name,
          enabled: s.enabled,
          active: s.active,
        })
      )
    );

    return res.status(201).json({ message: `${records.length} services enregistrés.` });
  } catch (error) {
    console.error("Erreur enregistrement services:", error);
    return res.status(500).json({ message: "Erreur serveur", error: error.message });
  }
};