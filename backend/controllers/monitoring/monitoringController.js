const fs = require('fs');
const path = require('path');
const { getRemoteFileContent, getRemoteJSON } = require('../../utils/sshClient');
const { Monitoring, UserSetting, Deployment } = require('../../models');
const { Op } = require('sequelize');

exports.collectMonitoringData = async (req, res) => {
  const user = req.user;
  const {
    vm_ip,
    host: bodyHost,
    username,
    privateKeyPath: bodyKeyPath,
    statusPath: bodyStatusPath,
    servicesPath: bodyServicesPath,
    instanceInfoPath: bodyInstanceInfoPath,
  } = req.body;

  const host = vm_ip || bodyHost;

  if (!host || !username) {
    return res.status(400).json({ message: '❌ Champs requis : vm_ip/host et username' });
  }

  const settings = await UserSetting.findOne({ where: { user_id: user.id } });

  const sshUser = username || settings?.proxmox_ssh_user;
  const privateKeyPath = bodyKeyPath || settings?.ssh_private_key_path;
  const statusPath =
    bodyStatusPath ||
    settings?.statuspath ||
    process.env.STATUS_JSON_PATH ||
    '/opt/monitoring/status.json';
  const servicesPath =
    bodyServicesPath ||
    settings?.servicespath ||
    process.env.SERVICES_JSON_PATH ||
    '/opt/monitoring/services_status.json';
  const instanceInfoPath =
    bodyInstanceInfoPath ||
    settings?.instanceinfopath ||
    process.env.INSTANCE_INFO_PATH ||
    '/etc/instance-info.conf';

  if (!sshUser || !privateKeyPath) {
    return res.status(400).json({ message: '❌ Informations SSH incomplètes' });
  }

  let privateKey;
  try {
    privateKey = fs.readFileSync(path.resolve(privateKeyPath));
  } catch (err) {
    return res.status(500).json({ message: '❌ Lecture de la clé privée impossible', error: err.message });
  }

  try {
    console.log("🔐 Connexion SSH avec :");
    console.log("- host :", host);
    console.log("- username :", sshUser);
    console.log("- privateKeyPath :", privateKeyPath);
    console.log("- instanceInfoPath :", instanceInfoPath);

    let instanceId = null;
    try {
      const instanceInfoRaw = await getRemoteFileContent({
        host,
        username: sshUser,
        privateKey,
        filePath: instanceInfoPath,
      });
      const match = instanceInfoRaw.match(/^INSTANCE_ID=(.*)$/m);
      instanceId = match ? match[1].trim() : instanceInfoRaw.trim();
      if (!match) {
        console.warn('⚠️ INSTANCE_ID non trouvé dans instance-info.conf');
      }
    } catch (e) {
      console.warn('⚠️ Erreur lecture instance-info.conf :', e.message);
    }

    const servicesStatus = await getRemoteJSON({
      host,
      username: sshUser,
      privateKey,
      filePath: servicesPath,
    });

    const systemStatus = await getRemoteJSON({
      host,
      username: sshUser,
      privateKey,
      filePath: statusPath,
    });

    const record = await Monitoring.create({
      vm_ip: host,
      ip_address: systemStatus.ip_address,
      instance_id: instanceId,
      services_status: servicesStatus,
      system_status: systemStatus,
      retrieved_at: new Date(),
    });

    res.json(record);
  } catch (err) {
    console.error('🚨 Erreur lors de la collecte des données de monitoring :', err.message);
    res.status(500).json({ message: '❌ Erreur lors de la collecte des données de monitoring', error: err.message });
  }
};


// 📋 Lister tous les enregistrements de monitoring
exports.getMonitoringRecords = async (req, res) => {
  try {
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;
    const offset = (page - 1) * limit;
    const { q, vm_ip } = req.query;

    const where = {};
    if (vm_ip) where.vm_ip = vm_ip;
    if (q) {
      where[Op.or] = [
        { vm_ip: { [Op.iLike]: `%${q}%` } },
        { ip_address: { [Op.iLike]: `%${q}%` } },
        { instance_id: { [Op.iLike]: `%${q}%` } },
      ];
    }

    const { count, rows } = await Monitoring.findAndCountAll({
      where,
      order: [['retrieved_at', 'DESC']],
      limit,
      offset,
    });

    res.json({
      data: rows,
      pagination: {
        total: count,
        page,
        pages: Math.ceil(count / limit),
        limit,
      },
    });
  } catch (err) {
    res.status(500).json({
      message: 'Erreur lors de la récupération des données',
      error: err.message,
    });
  }
};

// 📄 Récupérer un enregistrement précis
exports.getMonitoringRecordById = async (req, res) => {
  try {
    const record = await Monitoring.findByPk(req.params.id);
    if (!record) return res.status(404).json({ message: 'Enregistrement introuvable' });
    res.json(record);
  } catch (err) {
    res.status(500).json({ message: 'Erreur lors de la récupération', error: err.message });
  }
};

// 🌐 Vue d'ensemble du monitoring pour chaque serveur
exports.getOverview = async (req, res) => {
  try {
    const deployments = await Deployment.findAll();

    // Regrouper les services par serveur
    const serversMap = {};
    deployments.forEach((d) => {
      if (!serversMap[d.vm_id]) {
        serversMap[d.vm_id] = {
          id: d.vm_id,
          name: d.vm_name,
          ip: d.vm_ip,
          zone: d.zone,
          services: new Set(),
        };
      }
      if (d.service_name) serversMap[d.vm_id].services.add(d.service_name);
    });

    // Dernier enregistrement de monitoring par IP
    const records = await Monitoring.findAll({
      order: [['vm_ip', 'ASC'], ['retrieved_at', 'DESC']],
    });
    const latest = {};
    records.forEach((rec) => {
      if (!latest[rec.vm_ip]) latest[rec.vm_ip] = rec;
    });

    const servers = Object.values(serversMap).map((s) => {
      const monitor = latest[s.ip];
      let status = 'stopped';
      let os = 'unknown';
      let cpu_usage = 0;
      let memory_usage = 0;
      let memory_total = 0;
      let disk_usage = 0;
      let uptime = 'N/A';
      let last_monitoring = null;
      let active_services = 0;
      if (monitor) {
        last_monitoring = monitor.retrieved_at;
        const services = monitor.services_status?.services || [];
        active_services = services.filter((sv) => sv.active === 'active').length;
        const hasAlert = services.some((sv) => sv.active !== 'active');
        status = hasAlert ? 'error' : 'running';
        const system = monitor.system_status || {};
        os = system.os || system.hostname || 'unknown';
        cpu_usage = system.cpu_usage || system.cpu?.percent || 0;
        const mem = system.memory || {};
        memory_total = mem.total_kb || mem.total || 0;
        memory_usage = memory_total - (mem.available_kb || mem.free_kb || 0);
        const disk = system.disk || {};
        if (disk.total_bytes && disk.used_bytes) {
          disk_usage = Math.round((disk.used_bytes / disk.total_bytes) * 100);
        } else {
          disk_usage = system.disk_usage || 0;
        }
        uptime = system.uptime || system.uptime_sec || system.uptime_seconds || 'N/A';
      }
      return {
        id: s.id,
        name: s.name,
        ip: s.ip,
        status,
        os,
        cpu_usage,
        memory_usage,
        memory_total,
        disk_usage,
        uptime,
        services_count: s.services.size,
        active_services,
        last_monitoring: last_monitoring ? last_monitoring.toISOString() : null,
      };
    });

    const summary = {
      total: servers.length,
      running: servers.filter((s) => s.status === 'running').length,
      stopped: servers.filter((s) => s.status === 'stopped').length,
      error: servers.filter((s) => s.status === 'error').length,
    };

    res.json({ summary, vms: servers });
  } catch (err) {
    res
      .status(500)
      .json({ message: "Erreur lors de l'obtention de l'aperçu", error: err.message });
  }
};

// 🔁 Mettre à jour l'IP d'une VM dans la table deployments
exports.syncDeploymentIP = async (req, res) => {
  const { instance_id, vm_ip } = req.body;
  if (!instance_id || !vm_ip) {
    return res.status(400).json({ message: 'instance_id et vm_ip requis' });
  }
  try {
    const deployment = await Deployment.findOne({ where: { instance_id } });
    if (!deployment) {
      return res.status(404).json({ message: 'Déploiement introuvable' });
    }
    const updated = deployment.vm_ip !== vm_ip;
    if (updated) await deployment.update({ vm_ip });
    res.json({ message: 'Synchronisation effectuée', updated });
  } catch (err) {
    res.status(500).json({ message: 'Erreur lors de la synchronisation', error: err.message });
  }
};