// controllers/infrastructure.controller.js
"use strict";

const axios = require("axios");
const https = require("https");
const { Deployment, Delete, Monitoring, UserSetting, Log, User, Alert, Sequelize } = require("../../models");
const { analyzeDeploymentStats } = require("../../services/iaService");
const { randomUUID } = require("crypto");

const httpsAgent = new https.Agent({ rejectUnauthorized: false });
let lastInfrastructureMap = [];

/* ------------------------ Helpers ------------------------ */
function extractLatestMonitoring(records) {
  const map = {};
  records.forEach((rec) => {
    if (!map[rec.vm_ip]) map[rec.vm_ip] = rec; // records déjà triés par retrieved_at DESC
  });
  return map;
}

/**
 * Récupère les VMs Proxmox pour un user (via ses settings)
 * Lance des erreurs explicites si settings absents / API en échec
 */
async function fetchProxmoxVMsForUser(userId) {
  const settings = await UserSetting.findOne({ where: { user_id: userId } });
  if (!settings) {
    const err = new Error("Paramètres Proxmox introuvables");
    err.code = "NO_PVE_SETTINGS";
    throw err;
  }

  const headers = {
    Authorization: `PVEAPIToken=${settings.proxmox_api_token_id}!${settings.proxmox_api_token_name}=${settings.proxmox_api_token_secret}`,
  };

  const url = `${settings.proxmox_api_url}/cluster/resources?type=vm`;
  const resp = await axios.get(url, { httpsAgent, headers });
  const vms = resp.data?.data || [];

  return {
    vms: vms.map((v) => ({
      vmid: String(v.vmid),
      name: v.name || `vm-${v.vmid}`,
      template: v.template === 1,
      raw: v,
    })),
  };
}


/* ------------------------------ Summary ------------------------------ */

exports.getSummary = async (req, res) => {
  try {
    const totalServers = await Deployment.count({ distinct: true, col: "vm_id" });
    const totalServices = await Deployment.count({ distinct: true, col: "service_name" });
    const monitoredServers = await Monitoring.count({ distinct: true, col: "vm_ip" });

    const records = await Monitoring.findAll({
      order: [["vm_ip", "ASC"], ["retrieved_at", "DESC"]],
    });
    const latestMap = extractLatestMonitoring(records);

    let serversInAlert = 0;
    Object.values(latestMap).forEach((rec) => {
      const services = rec.services_status?.services || [];
      const hasAlert = services.some((s) => s.active !== "active");
      if (hasAlert) serversInAlert += 1;
    });

    const supervisedPercentage = totalServers
      ? Math.round((monitoredServers / totalServers) * 100)
      : 0;

    res.json({ totalServers, totalServices, serversInAlert, supervisedPercentage });
  } catch (err) {
    res.status(500).json({ message: "Erreur lors du calcul du résumé", error: err.message });
  }
};

/* ------------------------------ Listing ------------------------------ */
/**
 * N'affiche que les serveurs présents en BD ET visibles dans Proxmox.
 * Intersection par vm_id (doit correspondre au vmid Proxmox).
 */
exports.listServers = async (req, res) => {
  try {
    // 1) Proxmox
    const { vms: proxmoxVms } = await fetchProxmoxVMsForUser(req.user.id);
    const liveVmidSet = new Set(proxmoxVms.map((v) => String(v.vmid)));

    // 2) BD (tous les déploiements, on regroupe par vm_id)
    const deployments = await Deployment.findAll();
    const serversMap = {};
    deployments.forEach((d) => {
      const vmid = String(d.vm_id || "");
      if (!vmid || !liveVmidSet.has(vmid)) return; // filtre : seulement si aussi dans Proxmox
      if (!serversMap[vmid]) {
        serversMap[vmid] = {
          id: vmid,
          name: d.vm_name,
          ip: d.vm_ip,
          zone: (d.zone || "").toUpperCase(),
          services: new Set(),
        };
      }
      if (d.service_name) serversMap[vmid].services.add(d.service_name);
    });

    // 3) Supervision (dernier état par IP)
    const records = await Monitoring.findAll({
      order: [["vm_ip", "ASC"], ["retrieved_at", "DESC"]],
    });
    const latestMap = extractLatestMonitoring(records);

    // 4) Projection + statut
    const servers = Object.values(serversMap).map((s) => {
      const monitor = latestMap[s.ip];
      let status = "unsupervised";
      let supervised = false;
      if (monitor) {
        supervised = true;
        const services = monitor.services_status?.services || [];
        const hasAlert = services.some((sv) => sv.active !== "active");
        status = hasAlert ? "alert" : "active";
      }
      return {
        id: s.id,
        name: s.name,
        ip: s.ip,
        zone: s.zone,
        services: Array.from(s.services),
        supervised,
        status,
      };
    });

    res.json(servers);
  } catch (err) {
    res
      .status(500)
      .json({ message: "Erreur lors de la récupération des serveurs", error: err.message });
  }
};

/* ------------------------------ CRUD ------------------------------ */

exports.createServer = async (req, res) => {
  try {
    const { name, ip, zone } = req.body;
    if (!name || !ip || !zone) {
      return res.status(400).json({ message: "Champs requis manquants" });
    }
    const vm_id = randomUUID();
    const server = await Deployment.create({
      vm_id,
      vm_name: name,
      vm_ip: ip,
      zone,
      operation_type: "manual",
      started_at: new Date(),
      status: "active",
    });
    res.status(201).json({ id: server.vm_id, name, ip, zone });
  } catch (err) {
    res
      .status(500)
      .json({ message: "Erreur lors de la création du serveur", error: err.message });
  }
};

exports.deleteServer = async (req, res) => {
  try {
    const id = req.params.id;
    const deleted = await Deployment.destroy({ where: { vm_id: id } });
    if (!deleted) {
      return res.status(404).json({ message: "Serveur introuvable" });
    }
    res.json({ id });
  } catch (err) {
    res
      .status(500)
      .json({ message: "Erreur lors de la suppression du serveur", error: err.message });
  }
};

/* --------------------------- Dashboard Data --------------------------- */

exports.getDashboardData = async (req, res) => {
  try {
    // Proxmox
    const { vms: proxmoxVms, headers, apiUrl } = await fetchProxmoxVMsForUser(req.user.id);
    const liveVmidSet = new Set(proxmoxVms.map((v) => String(v.vmid)));

    // Déploiements
    const deployments = await Deployment.findAll();
    const deploymentMap = {};
    deployments.forEach((d) => {
      const vmid = String(d.vm_id || "");
      // On ne comptabilise que les déploiements qui existent aussi dans Proxmox
      if (!vmid || !liveVmidSet.has(vmid)) return;
      deploymentMap[vmid] = d;
    });

    const totalDeployments = await Deployment.count();
    const successDeployments = await Deployment.count({
      where: {
        [Sequelize.Op.or]: [{ success: true }, { status: "success" }],
      },
    });
    const failedDeployments = await Deployment.count({
      where: {
        [Sequelize.Op.or]: [
          { success: false },
          { status: { [Sequelize.Op.in]: ["failed", "error"] } },
        ],
      },
    });

    const totalDeleted = await Delete.count();

    // Supervision
    const records = await Monitoring.findAll({
      order: [["vm_ip", "ASC"], ["retrieved_at", "DESC"]],
    });
    const latest = extractLatestMonitoring(records);

    // Compteurs
    let activeServices = 0;
    proxmoxVms.forEach((vm) => {
      const dep = deploymentMap[String(vm.vmid)];
      const ip = dep?.vm_ip;
      const monitor = ip ? latest[ip] : null;
      if (monitor) {
        const services = monitor.services_status?.services || [];
        activeServices += services.filter((s) => s.active === "active").length;
      }
    });

    const totalVms = Array.from(liveVmidSet).length;

    const alertRows = await Alert.findAll({
      where: { status: "open" },
      attributes: ["severity", [Sequelize.fn("COUNT", Sequelize.col("id")), "count"]],
      group: ["severity"],
      raw: true,
    });

    let critical = 0;
    let major = 0;
    let minor = 0;
    alertRows.forEach((row) => {
      if (row.severity === "critique") critical = Number(row.count);
      else if (row.severity === "majeure") major = Number(row.count);
      else if (row.severity === "mineure") minor = Number(row.count);
    });

    const serversInAlert = await Alert.count({
      where: { status: "open" },
      distinct: true,
      col: "server",
    });

    const systemHealth = totalVms
      ? Math.max(0, 100 - Math.round((serversInAlert / totalVms) * 100))
      : 100;

    // Logs
    const logs = await Log.findAll({
      include: [{ model: User, as: "user", attributes: ["email"] }],
      order: [["created_at", "DESC"]],
      limit: 5,
    });

    const deriveType = (action = "") => {
      if (/deploy/i.test(action)) return "deployment";
      if (/delete|destroy/i.test(action)) return "deletion";
      if (/restart|reboot/i.test(action)) return "restart";
      if (/user/i.test(action)) return "user_creation";
      if (/role/i.test(action)) return "role_change";
      return "vm_action";
    };

    const recentActivity = logs.map((log) => ({
      id: String(log.id),
      type: deriveType(log.action),
      message: log.user ? `${log.action} par ${log.user.email}` : log.action,
      timestamp: log.created_at,
    }));

    const now = new Date();
    const serverTz = Intl.DateTimeFormat().resolvedOptions().timeZone;

    res.json({
      totalVms,
      activeServices,
      alerts: { critical, major, minor },
      systemHealth,
      networkTraffic: { incoming: 0, outgoing: 0 },
      recentActivity,
      lastUpdated: now.toISOString(),
      server_tz: serverTz,
      apiError: false,
      deploymentStats: {
        total: totalDeployments,
        success: successDeployments,
        failed_count: failedDeployments,
        deleted: totalDeleted,
      },
    });
  } catch (err) {
    res
      .status(500)
      .json({ message: "Erreur lors de la récupération du tableau de bord", error: err.message });
  }
};

/* ------------------------ Deployment stats & IA ------------------------ */

async function collectDeploymentStats(period = "day") {
  const deployments = await Deployment.findAll({
    attributes: ["started_at", "success", "status"],
    raw: true,
  });
  const deletions = await Delete.findAll({ attributes: ["deleted_at"], raw: true });

  const formatKey = (date) => {
    const d = new Date(date);
    if (period === "month") return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, "0")}`;
    if (period === "week") {
      const firstJan = new Date(d.getFullYear(), 0, 1);
      const day = Math.floor((d - firstJan) / 86400000);
      const week = Math.ceil((day + firstJan.getDay() + 1) / 7);
      return `${d.getFullYear()}-W${String(week).padStart(2, "0")}`;
    }
    return d.toISOString().slice(0, 10);
  };

  const map = {};
  deployments.forEach((dep) => {
    if (!dep.started_at) return;
    const key = formatKey(dep.started_at);
    if (!map[key]) map[key] = { period: key, deployed: 0, deleted: 0, success: 0, failed: 0 };
    map[key].deployed += 1;
    if (dep.success === true || dep.status === "success") map[key].success += 1;
    if (dep.success === false || ["failed", "error"].includes(dep.status)) map[key].failed += 1;
  });
  deletions.forEach((del) => {
    if (!del.deleted_at) return;
    const key = formatKey(del.deleted_at);
    if (!map[key]) map[key] = { period: key, deployed: 0, deleted: 0, success: 0, failed: 0 };
    map[key].deleted += 1;
  });
  const timeline = Object.values(map).sort((a, b) => (a.period < b.period ? -1 : 1));

  const total = deployments.length;
  const success = deployments.filter((d) => d.success === true || d.status === "success").length;
  const failed_count = deployments.filter(
    (d) => d.success === false || ["failed", "error"].includes(d.status)
  ).length;
  const deleted = deletions.length;

  return { totals: { deployed: total, success, failed_count, deleted }, timeline };
}

exports.getDeploymentStats = async (req, res) => {
  try {
    const period = req.query.period || "day";
    const stats = await collectDeploymentStats(period);

    const allDeployments = await Deployment.findAll({ raw: true });
    const allDeletes = await Delete.findAll({ raw: true });

    const now = new Date();
    const sevenDaysAgo = new Date(now.getTime() - 7 * 86400000);
    const thirtyDaysAgo = new Date(now.getTime() - 30 * 86400000);

    const within = (d, from) => d.started_at && new Date(d.started_at) >= from;
    const successRate7dDeploys = allDeployments.filter((d) => within(d, sevenDaysAgo));
    const successRate30dDeploys = allDeployments.filter((d) => within(d, thirtyDaysAgo));
    const successRate7d = successRate7dDeploys.length
      ? successRate7dDeploys.filter((d) => d.success === true).length / successRate7dDeploys.length
      : 0;
    const successRate30d = successRate30dDeploys.length
      ? successRate30dDeploys.filter((d) => d.success === true).length / successRate30dDeploys.length
      : 0;

    const durationSecs = allDeployments
      .filter((d) => d.started_at && d.ended_at)
      .map((d) => (new Date(d.ended_at) - new Date(d.started_at)) / 1000)
      .sort((a, b) => a - b);
    const medianDeploymentTimeSec = durationSecs.length
      ? durationSecs[Math.floor(durationSecs.length / 2)]
      : 0;

    const failureMap = {};
    allDeployments
      .filter((d) => d.success === false)
      .forEach((d) => {
        const key = d.service_name || "unknown";
        failureMap[key] = (failureMap[key] || 0) + 1;
      });
    const topFailureCauses = Object.entries(failureMap)
      .sort((a, b) => b[1] - a[1])
      .slice(0, 5)
      .map(([cause, count]) => ({ cause, count }));

    const deploymentsByZone = { LAN: 0, DMZ: 0, WAN: 0, MGMT: 0 };
    allDeployments.forEach((d) => {
      const zone = (d.zone || "LAN").toUpperCase();
      deploymentsByZone[zone] = (deploymentsByZone[zone] || 0) + 1;
    });

    const depByInstance = {};
    allDeployments.forEach((d) => {
      if (d.instance_id) depByInstance[d.instance_id] = d;
    });
    const destroyDurations = allDeletes
      .map((del) => {
        const dep = depByInstance[del.instance_id];
        if (dep && dep.started_at && del.deleted_at) {
          return (new Date(del.deleted_at) - new Date(dep.started_at)) / 1000;
        }
        return null;
      })
      .filter((v) => v != null);
    const avgDestroyTimeSec = destroyDurations.length
      ? destroyDurations.reduce((a, b) => a + b, 0) / destroyDurations.length
      : 0;

    // Capacité de stockage (facultatif)
    let storageCapacity = [];
    try {
      const { headers, apiUrl } = await fetchProxmoxVMsForUser(req.user.id);
      const storagesUrl = `${apiUrl}/cluster/resources?type=storage`;
      const resp = await axios.get(storagesUrl, { httpsAgent, headers });
      storageCapacity = (resp.data?.data || []).map((s) => ({
        datastore: s.storage,
        total_bytes: s.maxdisk,
        used_bytes: s.used,
      }));
    } catch {
      storageCapacity = [];
    }

    res.json({
      ...stats,
      successRate7d,
      successRate30d,
      medianDeploymentTimeSec,
      topFailureCauses,
      storageCapacity,
      deploymentsByZone,
      avgDestroyTimeSec,
    });
  } catch (err) {
    res.status(500).json({ message: "Erreur lors du calcul des statistiques", error: err.message });
  }
};

exports.getDeploymentInsights = async (req, res) => {
  try {
    const period = req.query.period || "day";
    const stats = await collectDeploymentStats(period);
    const analysis = await analyzeDeploymentStats(stats);
    res.json({ analysis });
  } catch (err) {
    res
      .status(500)
      .json({ message: "Erreur lors de l'analyse des statistiques", error: err.message });
  }
};

/* ------------------------ Infrastructure Map ------------------------ */
/**
 * Affiche UNIQUEMENT les VMs présentes dans Proxmox ET en BD avec status "apply".
 * Jointure stricte sur (vmid, name), en prenant le DERNIER enregistrement (created_at) côté BD.
 */
exports.getInfrastructureMap = async (req, res) => {
  const errors = [];
  try {
    /* 1) Proxmox (live) */
    let proxmoxVms = [];
    try {
      const result = await fetchProxmoxVMsForUser(req.user.id);
      proxmoxVms = result.vms;
    } catch (e) {
      if (e.code === "NO_PVE_SETTINGS") {
        errors.push("Paramètres Proxmox introuvables.");
        return res.json({ status: "degraded", errors, servers: lastInfrastructureMap });
      }
      errors.push(`Erreur API Proxmox: ${e.message}`);
      return res.json({ status: "degraded", errors, servers: lastInfrastructureMap });
    }

    if (proxmoxVms.length === 0) {
      lastInfrastructureMap = [];
      return res.json({ status: "ok", servers: [] });
    }

    // Clés Proxmox par (vmid::name)
    const pveKey = (vm) => `${vm.vmid}::${(vm.name || "").trim()}`;
    const pveKeySet = new Set(proxmoxVms.map(pveKey));

    /* 2) Deployments en mode "apply" (on sélectionne UNIQUEMENT le plus récent par (vm_id, vm_name)) */
    let deploymentsApply = [];
    try {
      const all = await Deployment.findAll({
        where: { operation_type: "apply" },
        order: [["created_at", "DESC"]], // ou ["started_at","DESC"] si tu préfères
      });

      // Garder le DERNIER par (vm_id, vm_name)
      const latestByComposite = {};
      for (const d of all) {
        const key = `${String(d.vm_id)}::${(d.vm_name || "").trim()}`;
        if (!latestByComposite[key]) latestByComposite[key] = d; // déjà trié DESC
      }
      deploymentsApply = Object.values(latestByComposite);
    } catch (e) {
      errors.push("Impossible de récupérer les déploiements (apply)");
      return res.json({ status: "degraded", errors, servers: lastInfrastructureMap });
    }

    if (deploymentsApply.length === 0) {
      lastInfrastructureMap = [];
      return res.json({ status: "ok", servers: [] });
    }

    /* 3) Intersection stricte PVE ↔ BD sur (vmid, name) */
    const deploymentByKey = {};
    for (const d of deploymentsApply) {
      const key = `${String(d.vm_id)}::${(d.vm_name || "").trim()}`;
      // On ne retient que ceux qui existent côté Proxmox
      if (pveKeySet.has(key) && !deploymentByKey[key]) {
        deploymentByKey[key] = d;
      }
    }

    const intersectingPve = proxmoxVms.filter((vm) => deploymentByKey[pveKey(vm)]);
    if (intersectingPve.length === 0) {
      lastInfrastructureMap = [];
      return res.json({ status: "ok", servers: [] });
    }

    /* 4) Supervision (dernier record par IP) */
    let latestMap = {};
    try {
      const records = await Monitoring.findAll({
        order: [["vm_ip", "ASC"], ["retrieved_at", "DESC"]],
      });
      latestMap = extractLatestMonitoring(records);
    } catch (e) {
      errors.push("Impossible de récupérer la supervision");
      // on continue quand même : status=unsupervised par défaut
    }

    /* 5) Construction des serveurs (intersection & enrichissement) */
    const servers = intersectingPve.map((vm) => {
      const dep = deploymentByKey[pveKey(vm)];
      const ip = dep?.vm_ip || "N/A";
      const zone = (dep?.zone || "LAN").toUpperCase();

      const monitor = ip ? latestMap[ip] : null;
      let status = "unsupervised";
      let uptime = "N/A";
      if (monitor) {
        const services = monitor.services_status?.services || [];
        const hasAlert = services.some((sv) => sv.active !== "active");
        status = hasAlert ? "alert" : "ok";
        uptime = monitor.system_status?.uptime || monitor.system_status?.uptime_sec || "N/A";
      }

      return {
        id: String(vm.vmid),
        name: dep?.vm_name || vm.name || `vm-${vm.vmid}`,
        ip,
        zone,
        role: dep?.service_name || "unknown",
        isTemplate: !!vm.template,
        status,
        uptime,
      };
    });

    /* 6) Placement sur la carte (grille par zone) */
    const zoneLayouts = {
      MGMT: { left: 0.05, top: 0.02, width: 0.4, height: 0.08 }, // MGMT agrandi
      LAN: { left: 0.05, top: 0.12, width: 0.4, height: 0.78 },
      DMZ: { left: 0.55, top: 0.12, width: 0.4, height: 0.42 },
      WAN: { left: 0.55, top: 0.58, width: 0.4, height: 0.32 },
      DEFAULT: { left: 0, top: 0, width: 1, height: 1 },
    };
    const zoneCounters = { MGMT: 0, LAN: 0, DMZ: 0, WAN: 0, DEFAULT: 0 };

    const positioned = servers.map((s) => {
      const layout = zoneLayouts[s.zone] || zoneLayouts.DEFAULT;
      const zoneKey = Object.prototype.hasOwnProperty.call(zoneCounters, s.zone) ? s.zone : "DEFAULT";
      const idx = zoneCounters[zoneKey];
      const cols = 5;
      const x = layout.left + ((idx % cols) + 0.5) * (layout.width / cols);
      const y = layout.top + (Math.floor(idx / cols) + 0.5) * (layout.height / cols);
      zoneCounters[zoneKey] += 1;
      return { ...s, position: { x, y } };
    });

    lastInfrastructureMap = positioned;

    if (errors.length) return res.json({ status: "degraded", servers: positioned, errors });
    return res.json({ status: "ok", servers: positioned });
  } catch (err) {
    console.error("Infrastructure map error:", err.message);
    return res.json({ status: "degraded", servers: lastInfrastructureMap, errors: [err.message] });
  }
};
