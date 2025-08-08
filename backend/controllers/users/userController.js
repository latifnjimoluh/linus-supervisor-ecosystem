const { Op } = require('sequelize');
const userService = require('../../services/userService');
const { validateCreate, validateUpdate } = require('../../validators/userValidator');
const logger = require('../../utils/logger');

exports.getAllUsers = async (req, res) => {
  logger.info('getAllUsers called', req.query);
  try {
    const { count, rows, page, limit } = await userService.getAllUsers(req.query);
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
    next(error);
  }
};

exports.getUserById = async (req, res) => {
  logger.info('getUserById called', req.params.id);
  const { id } = req.params;
  try {
    const user = await userService.getUserById(id);
    if (!user) {
      return res.status(404).json({ message: 'Utilisateur introuvable.' });
    }
    res.json(user);
  } catch (error) {
    next(error);
  }
};

exports.searchUsers = async (req, res) => {
  logger.info('searchUsers called', req.query.q);
  const { q } = req.query;
  if (!q) {
    logger.warn('Paramètre q manquant');
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
    logger.info(`${users.length} users matched search`);
    res.json(users);
  } catch (error) {
    logger.error('Erreur recherche utilisateurs:', error);
    next(error);
  }
};

exports.createUser = async (req, res) => {
  logger.info('createUser called', req.body.email);
  try {
    const { error } = validateCreate(req.body);
    if (error) {
      return res.status(400).json({ message: error });
    }
    const existing = await userService.findByEmail(req.body.email);
    if (existing) {
      return res.status(400).json({ message: 'Email déjà utilisé.' });
    }
    const user = await userService.createUser(req.body);
    res.status(201).json({ message: 'Utilisateur créé avec succès', user });
  } catch (err) {
    next(err);
  }
};

exports.updateUser = async (req, res) => {
  logger.info('updateUser called', req.params.id, req.body);
  const { id } = req.params;
  const { first_name, last_name, phone, status, role_id } = req.body;

  try {
    const user = await User.findByPk(id);
    if (!user) {
      logger.warn('Utilisateur introuvable');
      return res.status(404).json({ message: 'Utilisateur introuvable.' });
    }

    user.first_name = first_name ?? user.first_name;
    user.last_name = last_name ?? user.last_name;
    user.phone = phone ?? user.phone;
    user.status = status ?? user.status;
    user.role_id = role_id ?? user.role_id;

    await user.save();
    logger.info('Utilisateur mis à jour', user.email);
    res.json({ message: 'Utilisateur mis à jour avec succès', user });
  } catch (error) {
    logger.error('Erreur modification utilisateur:', error);
    next(error);
  }
};

exports.patchUser = async (req, res) => {
  logger.info('patchUser called', req.params.id, req.body);
  const { id } = req.params;
  try {
    const user = await User.findByPk(id);
    if (!user) {
      logger.warn('Utilisateur introuvable');
      return res.status(404).json({ message: 'Utilisateur introuvable.' });
    }

    const allowed = ['first_name', 'last_name', 'phone', 'status', 'role_id'];
    allowed.forEach((field) => {
      if (req.body[field] !== undefined) {
        user[field] = req.body[field];
      }
    });

    await user.save();
    logger.info('Utilisateur mis à jour (patch)', user.email);
    res.json({ message: 'Utilisateur mis à jour avec succès', user });
  } catch (error) {
    logger.error('Erreur patch utilisateur:', error);
    next(error);
  }
};

exports.softDeleteUser = async (req, res) => {
  logger.info('softDeleteUser called', req.params.id);
  const { id } = req.params;

  try {
    const user = await User.findByPk(id);
    if (!user) {
      logger.warn('Utilisateur introuvable');
      return res.status(404).json({ message: 'Utilisateur introuvable.' });
    }

    user.status = 'inactif';
    await user.save();

    logger.info('Utilisateur désactivé', user.email);
    res.json({ message: 'Utilisateur désactivé (suppression logique) avec succès.' });
  } catch (error) {
    logger.error('Erreur suppression utilisateur:', error);
    next(error);
  }
};
