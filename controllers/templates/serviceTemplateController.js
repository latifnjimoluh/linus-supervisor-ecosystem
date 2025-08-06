const fs = require('fs');
const path = require('path');
const { Op } = require('sequelize');
const { ServiceTemplate, GeneratedScript } = require('../../models');
const { logAction } = require('../../middlewares/log');
const {
  explainScript: explainScriptWithAI,
  analyzeAndImproveScript,
  explainTemplateVariables,
  summarizeDeploymentLogs,
  suggestSmartBundle,
  simulateScriptExecution,
} = require('../../services/iaService');

// 🔤 Fonction de nettoyage du nom (suppression des accents et des caractères spéciaux)
const sanitizeName = (str) => {
  return str
    .normalize('NFD')                         // décompose les lettres accentuées
    .replace(/[\u0300-\u036f]/g, '')          // supprime les accents
    .replace(/[^a-zA-Z0-9_-]/g, '_');         // remplace les caractères non autorisés
};

// 🔢 Génère le prochain numéro de fichier dans un dossier
const getNextFileNumber = (dir, prefix, ext) => {
  const files = fs.existsSync(dir) ? fs.readdirSync(dir) : [];
  const matching = files.filter(f => f.startsWith(prefix) && f.endsWith(ext));
  const numbers = matching.map(f => {
    const match = f.match(/\d+(\.sh)?$/);
    return match ? parseInt(match[0], 10) : 0;
  });
  const max = numbers.length ? Math.max(...numbers) : 0;
  return (max + 1).toString().padStart(3, '0');
};

// 📌 Créer un template et le sauvegarder
exports.createTemplate = async (req, res) => {
  console.log('📥 createTemplate called', req.body);
  const { name, service_type, category, description, template_content, fields_schema } = req.body;
@@ -106,50 +114,170 @@ exports.generateScript = async (req, res) => {

    fs.writeFileSync(filepath, script);
    console.log(`✅ Script généré et sauvegardé dans ${filepath}`);

    await GeneratedScript.create({
      template_id: tpl.id,
      category: tpl.category,
      service_type: tpl.service_type,
      script_path,
      abs_path: filepath,
      description: tpl.description,
    });

    await logAction(req, `generate_template_file:${tpl.id}:${filename}`);
    res.json({
      message: 'Script généré et sauvegardé',
      script,
      path: script_path,
    });
  } catch (err) {
    console.error('❌ Erreur generateScript:', err);
    res.status(500).json({ message: 'Erreur serveur.' });
  }
};

// 📝 Expliquer brièvement un script
exports.explainScript = async (req, res) => {
  const { script, entity_type, entity_id } = req.body;

  if (!script) {
    return res.status(400).json({ message: 'Script manquant.' });
  }

  try {
    const aiResponse = await explainScriptWithAI(script, {
      entityType: entity_type,
      entityId: entity_id,
    });
    res.status(200).json({ explanation: aiResponse });
  } catch (error) {
    console.error('Erreur explication IA:', error.message);
    res.status(500).json({ message: "Échec de l'explication IA." });
  }
};

// 🤖 Analyser un script de template avec l'IA
exports.analyzeScript = async (req, res) => {
  const { script, entity_type, entity_id } = req.body;

  if (!script) {
    return res.status(400).json({ message: 'Script manquant.' });
  }

  try {
    const aiResponse = await analyzeAndImproveScript(script, {
      entityType: entity_type,
      entityId: entity_id,
    });
    res.status(200).json({ analysis: aiResponse });
  } catch (error) {
    console.error('Erreur analyse IA:', error.message);
    res.status(500).json({ message: "Échec de l’analyse IA." });
  }
};

// ℹ️ Expliquer les variables d'un template
exports.explainVariables = async (req, res) => {
  const { template, entity_type, entity_id } = req.body;

  if (!template) {
    return res.status(400).json({ message: 'Template manquant.' });
  }

  try {
    const aiResponse = await explainTemplateVariables(template, {
      entityType: entity_type,
      entityId: entity_id,
    });
    res.status(200).json({ explanation: aiResponse });
  } catch (error) {
    console.error('Erreur explication variables IA:', error.message);
    res.status(500).json({ message: "Échec de l’explication des variables." });
  }
};

// 📋 Résumer les logs de déploiement
exports.summarizeLogs = async (req, res) => {
  const { logs, entity_type, entity_id } = req.body;

  if (!logs) {
    return res.status(400).json({ message: 'Logs manquants.' });
  }

  try {
    const aiResponse = await summarizeDeploymentLogs(logs, {
      entityType: entity_type,
      entityId: entity_id,
    });
    res.status(200).json({ summary: aiResponse });
  } catch (error) {
    console.error('Erreur résumé logs IA:', error.message);
    res.status(500).json({ message: "Échec du résumé des logs." });
  }
};

// 🧩 Proposer des packs d'installation intelligents
exports.suggestBundle = async (req, res) => {
  const { needs, entity_type, entity_id } = req.body;

  if (!needs) {
    return res.status(400).json({ message: 'Besoins manquants.' });
  }

  try {
    const aiResponse = await suggestSmartBundle(needs, {
      entityType: entity_type,
      entityId: entity_id,
    });
    res.status(200).json({ suggestion: aiResponse });
  } catch (error) {
    console.error('Erreur suggestion bundle IA:', error.message);
    res.status(500).json({ message: "Échec de la suggestion de bundle." });
  }
};

// 🧪 Simuler l'exécution d'un script
exports.simulateScript = async (req, res) => {
  const { script, entity_type, entity_id } = req.body;

  if (!script) {
    return res.status(400).json({ message: 'Script manquant.' });
  }

  try {
    const aiResponse = await simulateScriptExecution(script, {
      entityType: entity_type,
      entityId: entity_id,
    });
    res.status(200).json({ simulation: aiResponse });
  } catch (error) {
    console.error('Erreur simulation script IA:', error.message);
    res.status(500).json({ message: "Échec de la simulation du script." });
  }
};


// 📄 Récupérer tous les templates avec pagination et recherche
exports.getAllTemplates = async (req, res) => {
  console.log('📥 getAllTemplates called', req.query);
  try {
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;
    const offset = (page - 1) * limit;
    const sort = req.query.sort || 'created_at';
    const direction = req.query.order === 'asc' ? 'ASC' : 'DESC';
    const where = {};
    if (req.query.q) {
      const q = req.query.q;
      where[Op.or] = [
        { name: { [Op.iLike]: `%${q}%` } },
        { service_type: { [Op.iLike]: `%${q}%` } },
        { category: { [Op.iLike]: `%${q}%` } },
      ];
    }
    const { count, rows } = await ServiceTemplate.findAndCountAll({
      where,
      order: [[sort, direction]],
      limit,
      offset,
    });