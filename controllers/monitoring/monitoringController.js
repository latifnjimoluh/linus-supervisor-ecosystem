const fs = require('fs');
const path = require('path');
const axios = require('axios');
const https = require('https');
const ping = require('ping');
const { getRemoteFileContent, getRemoteJSON } = require('../../utils/sshClient');
const { Monitoring, UserSetting, Deployment } = require('../../models');
const { Op } = require('sequelize');

const httpsAgent = new https.Agent({ rejectUnauthorized: false });

async function getVMIPFromProxmox({ apiUrl, headers, node, vmid, type }) {
  const url = `${apiUrl}/nodes/${node}/${type}/${vmid}/agent/network-get-interfaces`;
  try {
    const resp = await axios.get(url, { httpsAgent, headers });
    const interfaces = resp.data?.data?.result || resp.data?.data || [];
    for (const iface of interfaces) {
      const addresses = iface['ip-addresses'] || iface['ip_addresses'] || [];
      for (const addr of addresses) {
        const ip = addr['ip-address'] || addr.address;
        if (ip && ip !== '127.0.0.1' && ip.includes('.')) {
          return ip;
        }
      }
    }
    return null;
  } catch (err) {
    console.error(`⚠️ IP introuvable via Proxmox pour VM ${vmid}:`, err.message);
    return null;
  }
}

async function isPingable(ip) {
  try {
    const result = await ping.promise.probe(ip);
    return result.alive;
  } catch (err) {
    console.error('⚠️ ping error:', err.message);
    return false;
  }
}

exports.collectMonitoringData = async (req, res) => {
  const user = req.user;
  const {
    vm_ip,
    username,
    privateKeyPath: bodyKeyPath,
    statusPath: bodyStatusPath,
    servicesPath: bodyServicesPath,
    instanceInfoPath: bodyInstanceInfoPath,
  } = req.body;

  const host = vm_ip;

  if (!host || !username) {
    return res.status(400).json({ message: '❌ Champs requis : vm_ip et username' });
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
// Récupère d'abord la liste des VMs depuis Proxmox puis
// y associe les dernières données de monitoring disponibles.
exports.getOverview = async (req, res) => {
  try {
    const settings = await UserSetting.findOne({ where: { user_id: req.user.id } });
    if (!settings) {
      return res.status(404).json({ message: 'Paramètres Proxmox introuvables.' });
    }

    // 🔹 Récupération des VMs depuis Proxmox
    const headers = {
      Authorization: `PVEAPIToken=${settings.proxmox_api_token_id}!${settings.proxmox_api_token_name}=${settings.proxmox_api_token_secret}`,
    };
    const proxmoxUrl = `${settings.proxmox_api_url}/cluster/resources?type=vm`;
    const proxmoxResp = await axios.get(proxmoxUrl, { httpsAgent, headers });
    const proxmoxVms = proxmoxResp.data?.data || [];

    // 🔹 Map des déploiements pour récupérer les IPs
    const deployments = await Deployment.findAll();
    const deploymentMap = {};
    deployments.forEach((d) => {
      deploymentMap[d.vm_id] = d;
    });

    // 🔹 Dernières données de monitoring par IP
    const records = await Monitoring.findAll({
      order: [['vm_ip', 'ASC'], ['retrieved_at', 'DESC']],
    });
    const latest = {};
    records.forEach((rec) => {
      if (!latest[rec.vm_ip]) latest[rec.vm_ip] = rec;
    });

    // 🔹 Construction de la réponse à partir des VMs Proxmox
    const servers = await Promise.all(
      proxmoxVms.map(async (vm) => {
        const dep = deploymentMap[vm.vmid] || {};
        let ip = await getVMIPFromProxmox({
          apiUrl: settings.proxmox_api_url,
          headers,
          node: vm.node,
          vmid: vm.vmid,
          type: vm.type,
        });
        if (!ip) ip = dep.vm_ip || null;

        const monitor = ip ? latest[ip] : null;

        let status = vm.status === 'running' ? 'running' : vm.status === 'stopped' ? 'stopped' : 'error';
        let os = 'unknown';
        let cpu_usage = 0;
        let memory_usage = 0;
        let memory_total = 0;
        let disk_usage = 0;
        let uptime = vm.uptime || 'N/A';
        let last_monitoring = null;
        let active_services = 0;
        let services_count = 0;
        let ping_ok = null;

        if (ip) {
          ping_ok = await isPingable(ip);
          // 🔁 Only flag an error if the VM is supposed to be running
          if (vm.status === 'running' && ping_ok === false) status = 'error';
        }

        if (monitor) {
          last_monitoring = monitor.retrieved_at;
          const services = monitor.services_status?.services || [];
          services_count = services.length;
          active_services = services.filter((sv) => sv.active === 'active').length;
          const hasAlert = services.some((sv) => sv.active !== 'active');
          // Only escalate to error when the VM is running
          status = status === 'running' && hasAlert ? 'error' : status;

          const system = monitor.system_status || {};
          os = system.os || system.hostname || os;
          cpu_usage = system.cpu_usage || system.cpu?.percent || cpu_usage;
          const mem = system.memory || {};
          memory_total = mem.total_kb || mem.total || 0;
          memory_usage = memory_total - (mem.available_kb || mem.free_kb || 0);
          const disk = system.disk || {};
          if (disk.total_bytes && disk.used_bytes) {
            disk_usage = Math.round((disk.used_bytes / disk.total_bytes) * 100);
          }
          uptime = system.uptime || system.uptime_sec || system.uptime_seconds || uptime;
        }

        // Fallback CPU usage from Proxmox data if monitoring is unavailable
        if (!cpu_usage && vm.cpu != null) {
          cpu_usage = vm.cpu * 100;
        }
        return {
          id: String(vm.vmid),
          name: vm.name || dep.vm_name || `VM ${vm.vmid}`,
          ip: ip || 'N/A',
          status,
          os,
          cpu_usage,
          memory_usage,
          memory_total,
          disk_usage,
          uptime,
          services_count,
          active_services,
          last_monitoring: last_monitoring ? last_monitoring.toISOString() : null,
          ping_ok,
          template: dep?.vm_specs?.template_name || '',
          created_at: dep?.createdAt ? dep.createdAt.toISOString() : null,
          instance_id: dep?.instance_id || null,
          is_template: vm.template === 1,
        };
      })
    );
    const vms = [];
    const templates = [];
    servers.forEach(({ is_template, ...rest }) => {
      if (is_template) templates.push(rest);
      else vms.push(rest);
    });

    const summary = {
      total: vms.length,
      running: vms.filter((s) => s.status === 'running').length,
      stopped: vms.filter((s) => s.status === 'stopped').length,
      error: vms.filter((s) => s.status === 'error').length,
    };

    res.json({ summary, vms, templates });
  } catch (err) {
    res.status(500).json({ message: "Erreur lors de l'obtention de l'aperçu", error: err.message });
  }
};

// 📋 Détails d'une VM spécifique (Proxmox + Monitoring)
exports.getVmDetails = async (req, res) => {
  try {
    const vmid = req.params.vmid;
    const settings = await UserSetting.findOne({ where: { user_id: req.user.id } });
    if (!settings) {
      return res.status(404).json({ message: 'Paramètres Proxmox introuvables.' });
    }

    const headers = {
      Authorization: `PVEAPIToken=${settings.proxmox_api_token_id}!${settings.proxmox_api_token_name}=${settings.proxmox_api_token_secret}`,
    };

    // Infos générales depuis Proxmox
    const listUrl = `${settings.proxmox_api_url}/cluster/resources?type=vm`;
    const listResp = await axios.get(listUrl, { httpsAgent, headers });
    const vmInfo = (listResp.data?.data || []).find((v) => String(v.vmid) === String(vmid));
    if (!vmInfo) {
      return res.status(404).json({ message: 'VM non trouvée dans Proxmox' });
    }

    // Détails de statut depuis Proxmox
    let statusInfo = {};
    try {
      const statusUrl = `${settings.proxmox_api_url}/nodes/${vmInfo.node}/${vmInfo.type}/${vmid}/status/current`;
      const statusResp = await axios.get(statusUrl, { httpsAgent, headers });
      statusInfo = statusResp.data?.data || {};
    } catch (_) {
      // Ignorer les erreurs de statut pour ne pas bloquer la réponse
    }

    // Dernier point RRD pour obtenir les métriques (CPU, réseau, load...)
    let rrdInfo = {};
    try {
      const rrdUrl = `${settings.proxmox_api_url}/nodes/${vmInfo.node}/${vmInfo.type}/${vmid}/rrddata?timeframe=hour`;
      const rrdResp = await axios.get(rrdUrl, { httpsAgent, headers });
      const points = rrdResp.data?.data || [];
      if (points.length) rrdInfo = points[points.length - 1] || {};
    } catch (_) {
      // Ignorer les erreurs RRD
    }
    // Récupération des infos locales et IP depuis Proxmox
    const deployment = await Deployment.findOne({ where: { vm_id: vmid } });
    let ip = await getVMIPFromProxmox({
      apiUrl: settings.proxmox_api_url,
      headers,
      node: vmInfo.node,
      vmid,
      type: vmInfo.type,
    });
    if (!ip) ip = deployment?.vm_ip || null;

    const monitor = ip
      ? await Monitoring.findOne({
          where: { vm_ip: ip },
          order: [['retrieved_at', 'DESC']],
        })
      : null;

    let ping_ok = null;
    let cpu_usage = 0;
    let memory_usage = 0;
    let memory_total = 0;
    let disk_usage = 0;
    let disk_total = 0;
    let network_in = 0;
    let network_out = 0;
    let load_average = 0;
    if (ip) ping_ok = await isPingable(ip);

    if (monitor) {
      const system = monitor.system_status || {};
      cpu_usage = system.cpu_usage || system.cpu?.percent || cpu_usage;
      const mem = system.memory || {};
      memory_total = mem.total_kb || mem.total || 0;
      memory_usage = memory_total - (mem.available_kb || mem.free_kb || 0);
      const disk = system.disk || {};
      if (disk.total_bytes && disk.used_bytes) {
        disk_total = disk.total_bytes / 1024; // KB
        disk_usage = disk.used_bytes / 1024; // KB
      } else if (disk.total_kb && disk.used_kb) {
        disk_total = disk.total_kb;
        disk_usage = disk.used_kb;
      }
      const net = system.network || {};
      if (net.rx_bytes != null) network_in = net.rx_bytes / 1024; // KB
      if (net.tx_bytes != null) network_out = net.tx_bytes / 1024; // KB
      if (system.load_average) load_average = parseFloat(String(system.load_average).split(/[ ,]/)[0]) || 0;
    }

    // ⚙️ Fallback sur les métriques Proxmox si pas de monitoring local
    if (!cpu_usage && statusInfo.cpu != null) cpu_usage = statusInfo.cpu * 100;
    if (!cpu_usage && rrdInfo.cpu != null && rrdInfo.maxcpu)
      cpu_usage = (rrdInfo.cpu / rrdInfo.maxcpu) * 100;
    if (!memory_total && statusInfo.maxmem != null) memory_total = statusInfo.maxmem / 1024; // bytes -> KB
    if (!memory_usage && statusInfo.mem != null) memory_usage = statusInfo.mem / 1024; // bytes -> KB
    if (!disk_total && statusInfo.maxdisk != null) disk_total = statusInfo.maxdisk / 1024; // bytes -> KB
    if (!disk_usage && statusInfo.disk != null) disk_usage = statusInfo.disk / 1024; // bytes -> KB
    if (!network_in && rrdInfo.netin != null) network_in = rrdInfo.netin / 1024; // B/s -> KB/s
    if (!network_out && rrdInfo.netout != null) network_out = rrdInfo.netout / 1024; // B/s -> KB/s
    if (!load_average) load_average = rrdInfo.loadavg || 0;
    res.json({
      id: String(vmid),
      name: vmInfo.name || deployment?.vm_name || `VM ${vmid}`,
      ip,
      ping_ok,
      cpu_usage,
      memory_usage,
      memory_total,
      disk_usage,
      disk_total,
      network_in,
      network_out,
      load_average,
      template: deployment?.vm_specs?.template_name || '',
      created_at: deployment?.createdAt ? deployment.createdAt.toISOString() : null,
      instance_id: deployment?.instance_id || monitor?.instance_id || null,
      proxmox: vmInfo,
      status: statusInfo,
      monitoring: monitor,
    });
  } catch (err) {
    res.status(500).json({ message: 'Erreur lors de la récupération du détail', error: err.message });
  }
};

// 📈 Historique des enregistrements pour une VM
exports.getVmHistory = async (req, res) => {
  try {
    const vmid = req.params.vmid;
    const settings = await UserSetting.findOne({ where: { user_id: req.user.id } });

    let ip = null;
    if (settings) {
      const headers = {
        Authorization: `PVEAPIToken=${settings.proxmox_api_token_id}!${settings.proxmox_api_token_name}=${settings.proxmox_api_token_secret}`,
      };
      try {
        const listUrl = `${settings.proxmox_api_url}/cluster/resources?type=vm`;
        const listResp = await axios.get(listUrl, { httpsAgent, headers });
        const vmInfo = (listResp.data?.data || []).find((v) => String(v.vmid) === String(vmid));
        if (vmInfo) {
          ip = await getVMIPFromProxmox({
            apiUrl: settings.proxmox_api_url,
            headers,
            node: vmInfo.node,
            vmid,
            type: vmInfo.type,
          });
        }
      } catch (_) {}
    }

    if (!ip) {
      const deployment = await Deployment.findOne({ where: { vm_id: vmid } });
      ip = deployment?.vm_ip || null;
    }

    if (!ip) {
      return res.status(404).json({ message: 'IP introuvable pour cette VM' });
    }

    const limit = parseInt(req.query.limit) || 50;
    const records = await Monitoring.findAll({
      where: { vm_ip: ip },
      order: [['retrieved_at', 'DESC']],
      limit,
    });

    res.json(records);
  } catch (err) {
    res.status(500).json({ message: "Erreur lors de la récupération de l'historique", error: err.message });
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

// 📊 Récupérer le résumé des VM depuis Proxmox
exports.getVmSummary = async (req, res) => {
  try {
    const settings = await UserSetting.findOne({ where: { user_id: req.user.id } });
    if (!settings) {
      return res.status(404).json({ message: 'Paramètres Proxmox introuvables.' });
    }

    const headers = {
      Authorization: `PVEAPIToken=${settings.proxmox_api_token_id}!${settings.proxmox_api_token_name}=${settings.proxmox_api_token_secret}`,
    };
    const url = `${settings.proxmox_api_url}/cluster/resources?type=vm`;
    const response = await axios.get(url, { httpsAgent, headers });
    const vms = response.data?.data || [];

    const summary = { total: vms.length, running: 0, stopped: 0, error: 0 };
    vms.forEach((vm) => {
      if (vm.status === 'running') summary.running += 1;
      else if (vm.status === 'stopped') summary.stopped += 1;
      else summary.error += 1;
    });

    res.json(summary);
  } catch (err) {
    res.status(500).json({ message: 'Erreur lors de la récupération des VM Proxmox', error: err.message });
  }
};
