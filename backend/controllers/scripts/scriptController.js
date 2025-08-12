const fs = require('fs');
const path = require('path');
const { GeneratedScript, Sequelize } = require('../../models');
const { logAction } = require('../../middlewares/log');
const { analyzeAndImproveScript } = require('../../services/iaService');

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

const listServiceTypes = async (req, res) => {
  try {
    const types = await GeneratedScript.findAll({
      attributes: [
        [Sequelize.fn('DISTINCT', Sequelize.col('service_type')), 'service_type']
      ],
      order: [['service_type', 'ASC']],
    });
    res.json(types.map(t => t.get('service_type')));
  } catch (err) {
    console.error('Erreur listServiceTypes:', err);
    res.status(500).json({ message: 'Erreur serveur.' });
  }
};

const listGeneratedScripts = async (req, res) => {
  try {
    const { category, service_type, status = 'actif' } = req.query;
    const where = {};
    if (category) where.category = category;
    if (service_type) where.service_type = service_type;
    if (status !== 'all') where.status = status;

    const scripts = await GeneratedScript.findAll({
      attributes: ['id', 'category', 'service_type', 'script_path', 'description', 'status'],
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

const analyzeScript = async (req, res) => {
  const { script } = req.body;
  if (!script) return res.status(400).json({ message: 'Script manquant.' });
  try {
    const aiResponse = await analyzeAndImproveScript(script, {
      entityType: 'script',
      entityId: req.params.id,
    });
    res.status(200).json({ analysis: aiResponse });
  } catch (err) {
    console.error('Erreur analyzeScript:', err);
    res.status(500).json({ message: "Échec de l'analyse IA." });
  }
};

const deleteScript = async (req, res) => {
  try {
    const script = await GeneratedScript.findByPk(req.params.id);
    if (!script) return res.status(404).json({ message: 'Script introuvable' });
    script.status = 'supprime';
    await script.save();
    await logAction(req, `delete_script:${script.id}`);
    res.json({ message: 'Script supprimé' });
  } catch (err) {
    console.error('Erreur deleteScript:', err);
    res.status(500).json({ message: 'Erreur serveur.' });
  }
};

const restoreScript = async (req, res) => {
  try {
    const script = await GeneratedScript.findByPk(req.params.id);
    if (!script) return res.status(404).json({ message: 'Script introuvable' });
    script.status = 'actif';
    await script.save();
    await logAction(req, `restore_script:${script.id}`);
    res.json({ message: 'Script réactivé' });
  } catch (err) {
    console.error('Erreur restoreScript:', err);
    res.status(500).json({ message: 'Erreur serveur.' });
  }
};

module.exports = {
  preview,
  listGeneratedScripts,
  listServiceTypes,
  getGeneratedScript,
  analyzeScript,
  deleteScript,
  restoreScript,
};
