const axios = require('axios');
const https = require('https');
const { Deployment, Monitoring, UserSetting, Log, User } = require('../../models');
const { randomUUID } = require('crypto');

const httpsAgent = new https.Agent({ rejectUnauthorized: false });

function extractLatestMonitoring(records) {
  const map = {};
  records.forEach((rec) => {
    if (!map[rec.vm_ip]) map[rec.vm_ip] = rec;
  });
  return map;
}

exports.getSummary = async (req, res) => {
  try {
    const totalServers = await Deployment.count({ distinct: true, col: 'vm_id' });
    const totalServices = await Deployment.count({ distinct: true, col: 'service_name' });
    const monitoredServers = await Monitoring.count({ distinct: true, col: 'vm_ip' });

    const records = await Monitoring.findAll({
      order: [['vm_ip', 'ASC'], ['retrieved_at', 'DESC']],
    });
    const latestMap = extractLatestMonitoring(records);
    let serversInAlert = 0;
    Object.values(latestMap).forEach((rec) => {
      const services = rec.services_status?.services || [];
      const hasAlert = services.some((s) => s.active !== 'active');
      if (hasAlert) serversInAlert += 1;
    });
    const supervisedPercentage = totalServers
      ? Math.round((monitoredServers / totalServers) * 100)
      : 0;

    res.json({ totalServers, totalServices, serversInAlert, supervisedPercentage });
  } catch (err) {
    res.status(500).json({ message: 'Erreur lors du calcul du résumé', error: err.message });
  }
};

exports.listServers = async (req, res) => {
  try {
    const deployments = await Deployment.findAll();
    const serversMap = {};
    deployments.forEach((d) => {
      if (!serversMap[d.vm_id]) {
        serversMap[d.vm_id] = {
          id: d.vm_id,
          name: d.vm_name,
          ip: d.vm_ip,
          zone: (d.zone || '').toUpperCase(),
          services: new Set(),
        };
      }
      if (d.service_name) serversMap[d.vm_id].services.add(d.service_name);
    });

    const records = await Monitoring.findAll({
      order: [['vm_ip', 'ASC'], ['retrieved_at', 'DESC']],
    });
    const latestMap = extractLatestMonitoring(records);

    const servers = Object.values(serversMap).map((s) => {
      const monitor = latestMap[s.ip];
      let status = 'unknown';
      let supervised = false;
      if (monitor) {
        supervised = true;
        const services = monitor.services_status?.services || [];
        const hasAlert = services.some((sv) => sv.active !== 'active');
        status = hasAlert ? 'alert' : 'active';
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
    res.status(500).json({ message: 'Erreur lors de la récupération des serveurs', error: err.message });
  }
};

exports.createServer = async (req, res) => {
  try {
    const { name, ip, zone } = req.body;
    if (!name || !ip || !zone) {
      return res.status(400).json({ message: 'Champs requis manquants' });
    }
    const vm_id = randomUUID();
    const server = await Deployment.create({
      vm_id,
      vm_name: name,
      vm_ip: ip,
      zone,
      operation_type: 'manual',
      started_at: new Date(),
      status: 'active',
    });
    res.status(201).json({ id: server.vm_id, name, ip, zone });
  } catch (err) {
    res.status(500).json({ message: 'Erreur lors de la création du serveur', error: err.message });
  }
};

exports.deleteServer = async (req, res) => {
  try {
    const id = req.params.id;
    const deleted = await Deployment.destroy({ where: { vm_id: id } });
    if (!deleted) {
      return res.status(404).json({ message: 'Serveur introuvable' });
    }
    res.json({ id });
  } catch (err) {
    res.status(500).json({ message: 'Erreur lors de la suppression du serveur', error: err.message });
  }
};

exports.getDashboardData = async (req, res) => {
  try {
    const settings = await UserSetting.findOne({ where: { user_id: req.user.id } });
    if (!settings) {
      return res.status(404).json({ message: 'Paramètres Proxmox introuvables.' });
    }

    const headers = {
      Authorization: `PVEAPIToken=${settings.proxmox_api_token_id}!${settings.proxmox_api_token_name}=${settings.proxmox_api_token_secret}`,
    };

    const proxmoxUrl = `${settings.proxmox_api_url}/cluster/resources?type=vm`;
    const proxmoxResp = await axios.get(proxmoxUrl, { httpsAgent, headers });
    const proxmoxVms = proxmoxResp.data?.data || [];

    const deployments = await Deployment.findAll();
    const deploymentMap = {};
    deployments.forEach((d) => {
      deploymentMap[d.vm_id] = d;
    });

    const records = await Monitoring.findAll({
      order: [['vm_ip', 'ASC'], ['retrieved_at', 'DESC']],
    });
    const latest = extractLatestMonitoring(records);

    let activeServices = 0;
    let critical = 0;
    proxmoxVms.forEach((vm) => {
      const dep = deploymentMap[vm.vmid];
      const ip = dep?.vm_ip;
      const monitor = ip ? latest[ip] : null;
      if (monitor) {
        const services = monitor.services_status?.services || [];
        activeServices += services.filter((s) => s.active === 'active').length;
        critical += services.filter((s) => s.active !== 'active').length;
      }
    });

    const totalVms = proxmoxVms.length;
    const systemHealth = totalVms ? Math.max(0, 100 - Math.round((critical / totalVms) * 100)) : 100;

    const logs = await Log.findAll({
      include: [{ model: User, as: 'user', attributes: ['email'] }],
      order: [['created_at', 'DESC']],
      limit: 5,
    });

    const deriveType = (action = '') => {
      if (/deploy/i.test(action)) return 'deployment';
      if (/delete|destroy/i.test(action)) return 'deletion';
      if (/restart|reboot/i.test(action)) return 'restart';
      if (/user/i.test(action)) return 'user_creation';
      if (/role/i.test(action)) return 'role_change';
      return 'vm_action';
    };

    const recentActivity = logs.map((log) => ({
      id: String(log.id),
      type: deriveType(log.action),
      message: log.user ? `${log.action} par ${log.user.email}` : log.action,
      timestamp: log.created_at,
    }));

    res.json({
      totalVms,
      activeServices,
      alerts: { critical, major: 0, minor: 0 },
      systemHealth,
      networkTraffic: { incoming: 0, outgoing: 0 },
      recentActivity,
      lastUpdated: new Date().toISOString(),
      apiError: false,
    });
  } catch (err) {
    res.status(500).json({ message: 'Erreur lors de la récupération du tableau de bord', error: err.message });
  }
};

exports.getInfrastructureMap = async (req, res) => {
  try {
    const settings = await UserSetting.findOne({ where: { user_id: req.user.id } });
    if (!settings) {
      return res.status(404).json({ message: 'Paramètres Proxmox introuvables.' });
    }

    const headers = {
      Authorization: `PVEAPIToken=${settings.proxmox_api_token_id}!${settings.proxmox_api_token_name}=${settings.proxmox_api_token_secret}`,
    };
    const proxmoxUrl = `${settings.proxmox_api_url}/cluster/resources?type=vm`;
    const proxmoxResp = await axios.get(proxmoxUrl, { httpsAgent, headers });
    const proxmoxVms = proxmoxResp.data?.data || [];

    // Map deployments by VM ID for quick lookup
    const deployments = await Deployment.findAll();
    const deploymentMap = {};
    deployments.forEach((d) => {
      if (!deploymentMap[d.vm_id]) {
        deploymentMap[d.vm_id] = d;
      }
    });

    // Latest monitoring records indexed by IP
    const records = await Monitoring.findAll({
      order: [['vm_ip', 'ASC'], ['retrieved_at', 'DESC']],
    });
    const latestMap = extractLatestMonitoring(records);

    // Build server list starting from Proxmox VMs and enriching with DB data
    const servers = proxmoxVms
      .map((vm) => {
        const dep = deploymentMap[vm.vmid];
        if (!dep) return null; // only keep VMs that exist in both Proxmox and DB

        const monitor = latestMap[dep.vm_ip];
        let status = 'unsupervised';
        let uptime = 'N/A';
        if (monitor) {
          const services = monitor.services_status?.services || [];
          const hasAlert = services.some((sv) => sv.active !== 'active');
          status = hasAlert ? 'alert' : 'ok';
          uptime = monitor.system_status?.uptime || monitor.system_status?.uptime_sec || 'N/A';
        }

        return {
          id: String(vm.vmid),
          name: dep.vm_name || vm.name,
          ip: dep.vm_ip,
          zone: (dep.zone || '').toUpperCase(),
          role: dep.service_name || 'unknown',
          isTemplate: vm.template === 1,
          status,
          uptime,
        };
      })
      .filter(Boolean);
    // Layout configuration for each zone expressed as ratios of the map container
    const zoneLayouts = {
      LAN: { left: 0.05, top: 0.1, width: 0.4, height: 0.8 },
      DMZ: { left: 0.55, top: 0.1, width: 0.4, height: 0.4 },
      WAN: { left: 0.55, top: 0.55, width: 0.4, height: 0.35 },
      DEFAULT: { left: 0, top: 0, width: 1, height: 1 },
    };
    const zoneCounters = { LAN: 0, DMZ: 0, WAN: 0, DEFAULT: 0 };

    // Determine position for each server within its zone using a simple grid
    const positioned = servers.map((s) => {
      const layout = zoneLayouts[s.zone] || zoneLayouts.DEFAULT;
      const zoneKey = zoneCounters.hasOwnProperty(s.zone) ? s.zone : 'DEFAULT';
      const idx = zoneCounters[zoneKey];
      const cols = 5; // grid columns per zone
      const x = layout.left + ((idx % cols) + 0.5) * (layout.width / cols);
      const y = layout.top + (Math.floor(idx / cols) + 0.5) * (layout.height / cols);
      zoneCounters[zoneKey] += 1;
      return { ...s, position: { x, y } };
    });

    res.json(positioned);
  } catch (err) {
    res.status(500).json({ message: 'Erreur lors de la récupération de la carte', error: err.message });
  }
};
