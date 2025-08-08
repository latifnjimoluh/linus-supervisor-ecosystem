const { Role } = require('../../models');
const { Op } = require('sequelize');

exports.getAllRoles = async (req, res) => {
  console.log('📥 getAllRoles called', req.query);
  try {
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;
    const offset = (page - 1) * limit;
    const sort = req.query.sort || 'name';
    const direction = req.query.order === 'desc' ? 'DESC' : 'ASC';
    const where = {};
    if (req.query.status) where.status = req.query.status;
    if (req.query.q) {
      const q = req.query.q;
      where[Op.or] = [
        { name: { [Op.iLike]: `%${q}%` } },
        { description: { [Op.iLike]: `%${q}%` } },
      ];
    }
    const { count, rows } = await Role.findAndCountAll({
      where,
      order: [[sort, direction]],
      limit,
      offset,
    });
    console.log(`📤 ${rows.length} roles found`);
    res.status(200).json({
      data: rows,
      pagination: {
        total: count,
        page,
        pages: Math.ceil(count / limit),
        limit,
      },
    });
  } catch (err) {
    console.error('Erreur getAllRoles:', err);
    res.status(500).json({ message: 'Erreur lors de la récupération des rôles', error: err.message });
  }
};

exports.getRoleById = async (req, res) => {
  console.log('📥 getRoleById called', req.params.id);
  try {
    const { id } = req.params;
    const role = await Role.findByPk(id);
    if (!role) {
      console.log('⚠️ Rôle non trouvé');
      return res.status(404).json({ message: 'Rôle non trouvé' });
    }
    console.log('📤 Role retrieved', role.name);
    res.status(200).json(role);
  } catch (err) {
    console.error('Erreur getRoleById:', err);
    res.status(500).json({ message: 'Erreur lors de la récupération du rôle', error: err.message });
  }
};

exports.createRole = async (req, res) => {
  console.log('📥 createRole called', req.body);
  try {
    const { name, description } = req.body;
    if (!name) {
      console.log('❌ nom manquant');
      return res.status(400).json({ message: 'Le nom du rôle est requis' });
    }

    const role = await Role.create({ name, description });
    console.log('✅ Rôle créé', role.name);
    res.status(201).json({ message: 'Rôle créé avec succès', role });
  } catch (err) {
    console.error('Erreur createRole:', err);
    res.status(500).json({ message: 'Erreur lors de la création du rôle', error: err.message });
  }
};

exports.updateRole = async (req, res) => {
  console.log('📥 updateRole called', req.params.id, req.body);
  try {
    const { id } = req.params;
    const { name, description } = req.body;

    const role = await Role.findByPk(id);
    if (!role) {
      console.log('⚠️ Rôle non trouvé');
      return res.status(404).json({ message: 'Rôle non trouvé' });
    }

    role.name = name || role.name;
    role.description = description || role.description;
    await role.save();

    console.log('✅ Rôle mis à jour', role.name);
    res.status(200).json({ message: 'Rôle mis à jour avec succès', role });
  } catch (err) {
    console.error('Erreur updateRole:', err);
    res.status(500).json({ message: 'Erreur lors de la mise à jour du rôle', error: err.message });
  }
};

exports.deleteRole = async (req, res) => {
  console.log('📥 deleteRole called', req.params.id);
  try {
    const id = req.params.id;

    const role = await Role.findByPk(id);
    if (!role) {
      console.log('⚠️ Rôle non trouvé');
      return res.status(404).json({ message: 'Rôle non trouvé.' });
    }

    role.status = 'inactif';
    await role.save();

    console.log('🗑️ Rôle désactivé', id);
    res.status(200).json({ message: 'Rôle désactivé (inactif).' });
  } catch (err) {
    console.error('Erreur deleteRole:', err);
    res.status(500).json({ message: 'Erreur lors de la désactivation du rôle.' });
  }
};
