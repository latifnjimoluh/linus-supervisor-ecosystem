const { ServiceTemplate } = require('../../models');
const { Op } = require('sequelize');
const { logAction } = require('../../middlewares/log');

exports.createTemplate = async (req, res) => {
  console.log('📥 createTemplate called', req.body);
  const { name, service_type, category, description, template_content, script_path, fields_schema } = req.body;
  try {
    const tpl = await ServiceTemplate.create({
      name,
      service_type,
      category,
      description,
      template_content,
      script_path,
      fields_schema,
    });
    await logAction(req, `create_template:${tpl.id}`);
    console.log('✅ Template créé', tpl.id);
    res.status(201).json(tpl);
  } catch (err) {
    console.error('❌ Erreur createTemplate:', err);
    res.status(500).json({ message: 'Erreur serveur.' });
  }
};

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
    console.log('📤 Templates retrieved:', rows.length);
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
    console.error('❌ Erreur getAllTemplates:', err);
    res.status(500).json({ message: 'Erreur serveur.' });
  }
};

exports.getTemplateById = async (req, res) => {
  console.log('📥 getTemplateById called', req.params.id);
  try {
    const tpl = await ServiceTemplate.findByPk(req.params.id);
    if (!tpl) {
      console.log('⚠️ Template non trouvé');
      return res.status(404).json({ message: 'Template non trouvé' });
    }
    res.json(tpl);
  } catch (err) {
    console.error('❌ Erreur getTemplateById:', err);
    res.status(500).json({ message: 'Erreur serveur.' });
  }
};

exports.updateTemplate = async (req, res) => {
  console.log('📥 updateTemplate called', req.params.id, req.body);
  try {
    const tpl = await ServiceTemplate.findByPk(req.params.id);
    if (!tpl) {
      console.log('⚠️ Template non trouvé');
      return res.status(404).json({ message: 'Template non trouvé' });
    }
    await tpl.update(req.body);
    await logAction(req, `update_template:${tpl.id}`);
    console.log('✅ Template mis à jour', tpl.id);
    res.json({ message: 'Template mis à jour', template: tpl });
  } catch (err) {
    console.error('❌ Erreur updateTemplate:', err);
    res.status(500).json({ message: 'Erreur serveur.' });
  }
};

exports.deleteTemplate = async (req, res) => {
  console.log('📥 deleteTemplate called', req.params.id);
  try {
    const tpl = await ServiceTemplate.findByPk(req.params.id);
    if (!tpl) {
      console.log('⚠️ Template non trouvé');
      return res.status(404).json({ message: 'Template non trouvé' });
    }
    tpl.status = 'inactif';
    await tpl.save();
    await logAction(req, `delete_template:${tpl.id}`);
    console.log('🗑️ Template désactivé', tpl.id);
    res.json({ message: 'Template désactivé' });
  } catch (err) {
    console.error('❌ Erreur deleteTemplate:', err);
    res.status(500).json({ message: 'Erreur serveur.' });
  }
};

exports.generateScript = async (req, res) => {
  console.log('📥 generateScript called', req.body);
  const { template_id, config_data } = req.body;

  if (!template_id || typeof config_data !== 'object') {
    console.log('⚠️ template_id ou config_data manquant');
    return res.status(400).json({ message: 'template_id et config_data requis' });
  }

  try {
    const tpl = await ServiceTemplate.findByPk(template_id);
    if (!tpl) {
      console.log('⚠️ Template non trouvé pour génération');
      return res.status(404).json({ message: 'Template non trouvé' });
    }

    // Vérification des champs requis à partir du schéma
    if (tpl.fields_schema && tpl.fields_schema.fields) {
      for (const field of tpl.fields_schema.fields) {
        if (field.required && !(field.name in config_data)) {
          console.log(`⛔ Champ requis manquant: ${field.name}`);
          return res.status(400).json({ message: `Champ requis manquant: ${field.name}` });
        }
      }
    }

    let script = tpl.template_content;
    for (const [key, value] of Object.entries(config_data)) {
      const regex = new RegExp(`{{${key}}}`, 'g');
      script = script.replace(regex, value);
    }

    await logAction(req, `generate_template:${tpl.id}`);
    console.log('✅ Script généré pour template', tpl.id);

    res.json({ script });
  } catch (err) {
    console.error('❌ Erreur generateScript:', err);
    res.status(500).json({ message: 'Erreur serveur.' });
  }
};
