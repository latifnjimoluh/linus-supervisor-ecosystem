const { GeneratedScript, Sequelize } = require('../../models');

const preview = (req, res) => {
  const { serverId, service } = req.params;
  const format = req.query.format === 'ansible' ? 'ansible' : 'bash';

  let script;
  if (format === 'ansible') {
    script = `- hosts: ${serverId}\n  tasks:\n    - name: Configure ${service}\n      debug: msg="Configure ${service} via Ansible"`;
  } else {
    script = `#!/bin/bash\n# Configure ${service} on server ${serverId}\necho "Configuring ${service}"`;
  }

  res.json({ format, script });
};

const listGeneratedScripts = async (req, res) => {
  try {
    const scripts = await GeneratedScript.findAll({
      attributes: ['id', 'category', 'service_type', 'script_path', 'description'],
      order: [['category', 'ASC'], ['id', 'ASC']],
    });
    const grouped = scripts.reduce((acc, script) => {
      const cat = script.category || 'uncategorized';
      if (!acc[cat]) acc[cat] = [];
      acc[cat].push(script);
      return acc;
    }, {});
    const result = Object.entries(grouped).map(([category, scripts]) => ({ category, scripts }));
    res.json(result);
  } catch (err) {
    console.error('Erreur listGeneratedScripts:', err);
    res.status(500).json({ message: 'Erreur serveur.' });
  }
};

const listServiceTypes = async (req, res) => {
  try {
    const types = await GeneratedScript.findAll({
      attributes: [[Sequelize.fn('DISTINCT', Sequelize.col('service_type')), 'service_type']],
      order: [['service_type', 'ASC']],
    });
    res.json(types.map(t => t.service_type));
  } catch (err) {
    console.error('Erreur listServiceTypes:', err);
    res.status(500).json({ message: 'Erreur serveur.' });
  }
};

module.exports = { preview, listGeneratedScripts, listServiceTypes };
