const { Deployment, Monitoring } = require('../../models');

function extractLatestMonitoring(records) {
  const map = {};
  records.forEach((rec) => {
    if (!map[rec.vm_ip]) map[rec.vm_ip] = rec;
  });
  return map;
}

exports.list = async (req, res) => {
  try {
    const deployments = await Deployment.findAll();
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

exports.getById = async (req, res) => {
  try {
    const { id } = req.params;
    const deployments = await Deployment.findAll({ where: { vm_id: id } });
    if (!deployments.length) {
      return res.status(404).json({ message: 'Serveur introuvable' });
    }
    const base = deployments[0];
    const services = deployments
      .map((d) => d.service_name)
      .filter(Boolean);

    const monitor = await Monitoring.findOne({
      where: { vm_ip: base.vm_ip },
      order: [['retrieved_at', 'DESC']],
    });

    let status = 'unknown';
    if (monitor) {
      const svc = monitor.services_status?.services || [];
      const hasAlert = svc.some((sv) => sv.active !== 'active');
      status = hasAlert ? 'alert' : 'active';
    }

    res.json({
      id: base.vm_id,
      name: base.vm_name,
      ip: base.vm_ip,
      zone: base.zone,
      services,
      supervised: !!monitor,
      status,
      system: monitor?.system_status || {},
      services_status: monitor?.services_status || {},
    });
  } catch (err) {
    res.status(500).json({ message: 'Erreur lors de la récupération du serveur', error: err.message });
  }
};

// Ajouter un serveur manuellement
exports.create = async (req, res) => {
  try {
    const { ip, name, zone } = req.body;
    if (!ip) return res.status(400).json({ message: 'IP requise' });

    const exists = await Deployment.findOne({ where: { vm_ip: ip } });
    if (exists) {
      return res.status(409).json({ message: 'Ce serveur existe déjà' });
    }

    const { v4: uuidv4 } = require('uuid');
    const vmId = uuidv4();

    await Deployment.create({
      vm_id: vmId,
      vm_ip: ip,
      vm_name: name || ip,
      zone,
      operation_type: 'register',
      status: 'registered',
      user_id: req.user?.id || 0,
      user_email: req.user?.email || '',
    });

    res.status(201).json({ id: vmId, ip, name: name || ip, zone });
  } catch (err) {
    res.status(500).json({ message: 'Erreur lors de l\'ajout du serveur', error: err.message });
  }
};

// Modifier les métadonnées d'un serveur
exports.update = async (req, res) => {
  try {
    const { id } = req.params;
    const { ip, name, zone } = req.body;
    const deployments = await Deployment.findAll({ where: { vm_id: id } });
    if (!deployments.length) {
      return res.status(404).json({ message: 'Serveur introuvable' });
    }

    if (ip && ip !== deployments[0].vm_ip) {
      const exists = await Deployment.findOne({ where: { vm_ip: ip } });
      if (exists) {
        return res.status(409).json({ message: 'Cette IP est déjà utilisée' });
      }
    }

    await Deployment.update(
      {
        vm_ip: ip || deployments[0].vm_ip,
        vm_name: name || deployments[0].vm_name,
        zone: zone || deployments[0].zone,
      },
      { where: { vm_id: id } }
    );

    res.json({ id, ip: ip || deployments[0].vm_ip, name: name || deployments[0].vm_name, zone: zone || deployments[0].zone });
  } catch (err) {
    res.status(500).json({ message: 'Erreur lors de la mise à jour du serveur', error: err.message });
  }
};

// Supprimer ou archiver un serveur
exports.remove = async (req, res) => {
  try {
    const { id } = req.params;
    const mode = req.query.mode || 'delete';

    const deployments = await Deployment.findAll({ where: { vm_id: id } });
    if (!deployments.length) {
      return res.status(404).json({ message: 'Serveur introuvable' });
    }

    if (mode === 'archive') {
      await Deployment.update({ status: 'archived' }, { where: { vm_id: id } });
    } else {
      await Deployment.destroy({ where: { vm_id: id } });
    }

    res.json({ message: 'Serveur supprimé' });
  } catch (err) {
    res.status(500).json({ message: 'Erreur lors de la suppression du serveur', error: err.message });
  }
};
