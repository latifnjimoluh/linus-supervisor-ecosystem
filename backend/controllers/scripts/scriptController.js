const fs = require('fs');
const path = require('path');
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
    const { category, service_type } = req.query;
    const where = {};
    if (category) where.category = category;
    if (service_type) where.service_type = service_type;

    const scripts = await GeneratedScript.findAll({
      attributes: ['id', 'category', 'service_type', 'script_path', 'description'],
      where,
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

const getGeneratedScript = async (req, res) => {
  try {
    const { id } = req.params;
    const script = await GeneratedScript.findByPk(id);
    if (!script) return res.status(404).json({ message: 'Script introuvable' });

    let content = null;
    if (script.abs_path && fs.existsSync(script.abs_path)) {
      content = fs.readFileSync(script.abs_path, 'utf-8');
    } else if (script.script_path) {
      const absPath = path.join(__dirname, `../../..${script.script_path}`);
      if (fs.existsSync(absPath)) content = fs.readFileSync(absPath, 'utf-8');
    }

    res.json({ ...script.toJSON(), content });
  } catch (err) {
    console.error('Erreur getGeneratedScript:', err);
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

module.exports = { preview, listGeneratedScripts, listServiceTypes, getGeneratedScript };
