const { Deployment, Monitoring } = require('../../models');
const { Op, fn, col } = require('sequelize');

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

exports.getDashboardData = async (req, res) => {
  try {
    const totalVms = await Deployment.count({ distinct: true, col: 'vm_id' });
    const activeServices = await Deployment.count({ distinct: true, col: 'service_name' });

    const records = await Monitoring.findAll({
      order: [['vm_ip', 'ASC'], ['retrieved_at', 'DESC']],
    });
    const latestMap = extractLatestMonitoring(records);

    let critical = 0;
    Object.values(latestMap).forEach((rec) => {
      const services = rec.services_status?.services || [];
      services.forEach((s) => {
        if (s.active !== 'active') critical += 1;
      });
    });

    const data = {
      totalVms,
      activeServices,
      alerts: { critical, major: 0, minor: 0 },
      systemHealth: Math.max(0, 100 - critical * 10),
      networkTraffic: { incoming: 0, outgoing: 0 },
      recentActivity: [],
      lastUpdated: new Date().toISOString(),
      apiError: false,
    };

    res.json(data);
  } catch (err) {
    res.status(500).json({ message: 'Erreur lors de la récupération du tableau de bord', error: err.message });
  }
};

exports.getInfrastructureMap = async (req, res) => {
  try {
    const deployments = await Deployment.findAll();
    const records = await Monitoring.findAll({
      order: [['vm_ip', 'ASC'], ['retrieved_at', 'DESC']],
    });
    const latestMap = extractLatestMonitoring(records);

    const serversMap = {};
    deployments.forEach((d) => {
      if (!serversMap[d.vm_id]) {
        serversMap[d.vm_id] = {
          id: d.vm_id,
          name: d.vm_name,
          ip: d.vm_ip,
          zone: (d.zone || '').toUpperCase(),
          role: d.service_name || 'unknown',
        };
      }
    });

    let index = 0;
    const servers = Object.values(serversMap).map((s) => {
      const monitor = latestMap[s.ip];
      let status = 'unsupervised';
      let uptime = 'N/A';
      if (monitor) {
        const services = monitor.services_status?.services || [];
        const hasAlert = services.some((sv) => sv.active !== 'active');
        status = hasAlert ? 'alert' : 'ok';
        uptime = monitor.system_status?.uptime || monitor.system_status?.uptime_sec || 'N/A';
      }
      const position = {
        x: (index % 5) / 5,
        y: Math.floor(index / 5) / 5,
      };
      index += 1;
      return { ...s, status, uptime, position };
    });

    res.json(servers);
  } catch (err) {
    res.status(500).json({ message: 'Erreur lors de la récupération de la carte', error: err.message });
  }
};
