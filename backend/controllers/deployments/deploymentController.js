const fs = require('fs');
const path = require('path');
const { Deployment } = require('../../models');

exports.getById = async (req, res) => {
  try {
    const { id } = req.params;
    const dep = await Deployment.findByPk(id);
    if (!dep) {
      return res.status(404).json({ message: 'Déploiement introuvable' });
    }

    let log = null;
    if (dep.log_path) {
      const absPath = path.resolve(dep.log_path);
      if (fs.existsSync(absPath)) {
        log = fs.readFileSync(absPath, 'utf8');
      }
    }

    res.json({
      id: dep.id,
      vm_name: dep.vm_name,
      template: dep.service_name,
      status: dep.status || (dep.success ? 'completed' : 'failed'),
      started_at: dep.started_at,
      ended_at: dep.ended_at,
      log,
    });
  } catch (err) {
    res.status(500).json({ message: 'Erreur lors de la récupération du déploiement', error: err.message });
  }
};
