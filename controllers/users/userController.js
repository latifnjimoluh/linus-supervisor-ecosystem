const bcrypt = require('bcrypt');
const { User, Role } = require('../../models');
const { Op } = require('sequelize');

exports.getAllUsers = async (req, res) => {
  console.log('📥 getAllUsers called', req.query);
  try {
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;
    const offset = (page - 1) * limit;
    const sort = req.query.sort || 'created_at';
    const direction = req.query.order === 'asc' ? 'ASC' : 'DESC';
    const order = [];
    if (sort === 'role') {
      order.push([{ model: Role, as: 'role' }, 'name', direction]);
    } else if (['first_name', 'email', 'created_at'].includes(sort)) {
      order.push([sort, direction]);
    } else {
      order.push(['created_at', 'DESC']);
    }

    const where = {};
    if (req.query.role) where.role_id = req.query.role;
    if (req.query.status) where.status = req.query.status;
    if (req.query.q) {
      const q = req.query.q;
      where[Op.or] = [
        { first_name: { [Op.iLike]: `%${q}%` } },
        { last_name: { [Op.iLike]: `%${q}%` } },
        { email: { [Op.iLike]: `%${q}%` } },
        { '$role.name$': { [Op.iLike]: `%${q}%` } },
      ];
    }

    const { count, rows } = await User.findAndCountAll({
      where,
      include: [{ model: Role, as: 'role' }],
      order,
      limit,
      offset,
    });

    console.log(`📤 ${rows.length} users found`);
    res.json({
      data: rows,
      pagination: {
        total: count,
        page,
        pages: Math.ceil(count / limit),
        limit,
      },
    });
  } catch (error) {
    console.error('Erreur récupération utilisateurs:', error);
    res
      .status(500)
      .json({ message: 'Erreur serveur lors de la récupération des utilisateurs.' });
  }
};

exports.getUserById = async (req, res) => {
  console.log('📥 getUserById called', req.params.id);
  const { id } = req.params;
  try {
    const user = await User.findByPk(id, {
      include: [{ model: Role, as: 'role' }],
    });

    if (!user) {
      console.log('⚠️ Utilisateur introuvable');
      return res.status(404).json({ message: 'Utilisateur introuvable.' });
    }

    console.log('📤 User retrieved', user.email);
    res.json(user);
  } catch (error) {
    console.error('Erreur récupération utilisateur:', error);
    res.status(500).json({ message: 'Erreur serveur.' });
  }
};

exports.searchUsers = async (req, res) => {
  console.log('📥 searchUsers called', req.query.q);
  const { q } = req.query;
  if (!q) {
    console.log('❌ Paramètre q manquant');
    return res.status(400).json({ message: "Paramètre 'q' requis." });
  }
  try {
    const users = await User.findAll({
      where: {
        [Op.or]: [
          { first_name: { [Op.iLike]: `%${q}%` } },
          { last_name: { [Op.iLike]: `%${q}%` } },
          { email: { [Op.iLike]: `%${q}%` } },
        ],
      },
      include: [{ model: Role, as: 'role' }],
      order: [['created_at', 'DESC']],
    });
    console.log(`📤 ${users.length} users matched search`);
    res.json(users);
  } catch (error) {
    console.error('Erreur recherche utilisateurs:', error);
    res.status(500).json({ message: 'Erreur serveur.' });
  }
};

exports.createUser = async (req, res) => {
  console.log('📥 createUser called', req.body.email);
  try {
    const {
      first_name,
      last_name,
      email,
      phone,
      password,
      role_id,
      status,
    } = req.body;

    if (!first_name || !last_name || !email || !password || !role_id) {
      console.log('❌ Champs requis manquants');
      return res.status(400).json({ message: 'Champs requis manquants.' });
    }

    const existing = await User.findOne({ where: { email } });
    if (existing) {
      console.log('⚠️ Email déjà utilisé');
      return res.status(400).json({ message: 'Email déjà utilisé.' });
    }

    const hashedPassword = await bcrypt.hash(password, 10);

    const user = await User.create({
      first_name,
      last_name,
      email,
      phone,
      password: hashedPassword,
      role_id,
      status: status || 'active',
    });

    console.log('✅ Utilisateur créé', user.email);
    res.status(201).json({ message: 'Utilisateur créé avec succès', user });
  } catch (error) {
    console.error('Erreur création utilisateur:', error);
    res.status(500).json({ message: 'Erreur serveur lors de la création.' });
  }
};

exports.updateUser = async (req, res) => {
  console.log('📥 updateUser called', req.params.id, req.body);
  const { id } = req.params;
  const { first_name, last_name, phone, status, role_id } = req.body;

  try {
    const user = await User.findByPk(id);
    if (!user) {
      console.log('⚠️ Utilisateur introuvable');
      return res.status(404).json({ message: 'Utilisateur introuvable.' });
    }

    user.first_name = first_name ?? user.first_name;
    user.last_name = last_name ?? user.last_name;
    user.phone = phone ?? user.phone;
    user.status = status ?? user.status;
    user.role_id = role_id ?? user.role_id;

    await user.save();
    console.log('✅ Utilisateur mis à jour', user.email);
    res.json({ message: 'Utilisateur mis à jour avec succès', user });
  } catch (error) {
    console.error('Erreur modification utilisateur:', error);
    res.status(500).json({ message: 'Erreur serveur.' });
  }
};

exports.patchUser = async (req, res) => {
  console.log('📥 patchUser called', req.params.id, req.body);
  const { id } = req.params;
  try {
    const user = await User.findByPk(id);
    if (!user) {
      console.log('⚠️ Utilisateur introuvable');
      return res.status(404).json({ message: 'Utilisateur introuvable.' });
    }

    const allowed = ['first_name', 'last_name', 'phone', 'status', 'role_id'];
    allowed.forEach((field) => {
      if (req.body[field] !== undefined) {
        user[field] = req.body[field];
      }
    });

    await user.save();
    console.log('✅ Utilisateur mis à jour (patch)', user.email);
    res.json({ message: 'Utilisateur mis à jour avec succès', user });
  } catch (error) {
    console.error('Erreur patch utilisateur:', error);
    res.status(500).json({ message: 'Erreur serveur.' });
  }
};

exports.softDeleteUser = async (req, res) => {
  console.log('📥 softDeleteUser called', req.params.id);
  const { id } = req.params;

  try {
    const user = await User.findByPk(id);
    if (!user) {
      console.log('⚠️ Utilisateur introuvable');
      return res.status(404).json({ message: 'Utilisateur introuvable.' });
    }

    user.status = 'inactif';
    await user.save();

    console.log('🗑️ Utilisateur désactivé', user.email);
    res.json({ message: 'Utilisateur désactivé (suppression logique) avec succès.' });
  } catch (error) {
    console.error('Erreur suppression utilisateur:', error);
    res.status(500).json({ message: 'Erreur serveur.' });
  }
};
