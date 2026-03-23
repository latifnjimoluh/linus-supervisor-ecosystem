const { UserSetting, User, Role } = require('../../models');
const { Op } = require('sequelize');

exports.getUserSettings = async (req, res) => {
  console.log('📥 getUserSettings called for user', req.user?.id);
  const userId = req.user?.id;

  try {
    const settings = await UserSetting.findOne({ where: { user_id: userId } });

    if (!settings) {
      console.log('⚠️ Aucun paramètre pour cet utilisateur');
      return res.status(404).json({ message: 'Aucun paramètre défini pour cet utilisateur.' });
    }

    console.log('📤 Paramètres récupérés');
    return res.status(200).json(settings);
  } catch (err) {
    console.error('❌ Erreur lors de la récupération des paramètres :', err);
    return res.status(500).json({ message: 'Erreur serveur.' });
  }
};

exports.getAccountInfo = async (req, res) => {
  console.log('📥 getAccountInfo called for user', req.user?.id);
  const userId = req.user?.id;
  try {
    const user = await User.findByPk(userId, {
      include: [{ model: Role, as: 'role', attributes: ['id', 'name', 'description'] }],
    });
    if (!user) {
      return res.status(404).json({ message: 'Utilisateur introuvable.' });
    }
    const settings = await UserSetting.findOne({ where: { user_id: userId } });
    return res.status(200).json({
      id: user.id,
      first_name: user.first_name,
      last_name: user.last_name,
      email: user.email,
      phone: user.phone,
      role: user.role,
      language: null,
      settings,
    });
  } catch (err) {
    console.error('❌ Erreur getAccountInfo:', err);
    return res.status(500).json({ message: 'Erreur serveur.' });
  }
};

exports.updateUserSettings = async (req, res) => {
  console.log('📥 updateUserSettings called for user', req.user?.id, req.body);
  const userId = req.user?.id;
  const updates = req.body;

  try {
    let settings = await UserSetting.findOne({ where: { user_id: userId } });

    if (!settings) {
      console.log('⚠️ Paramètres non trouvés pour mise à jour');
      return res.status(404).json({ message: 'Paramètres non trouvés. Veuillez d\'abord les créer.' });
    }

    await settings.update(updates);

    console.log('✅ Paramètres mis à jour');
    return res.status(200).json({ message: 'Paramètres mis à jour avec succès', settings });
  } catch (err) {
    console.error('❌ Erreur lors de la mise à jour des paramètres :', err);
    return res.status(500).json({ message: 'Erreur serveur.' });
  }
};

// 🎛️ Mettre à jour les préférences de stockage (nœud + stockage)
exports.updateStorageSettings = async (req, res) => {
  console.log('📥 updateStorageSettings called for user', req.user?.id, req.body);
  const userId = req.user?.id;
  const { proxmox_node, vm_storage } = req.body;

  try {
    let settings = await UserSetting.findOne({ where: { user_id: userId } });
    if (!settings) {
      return res.status(404).json({ message: 'Paramètres non trouvés. Veuillez d\'abord les créer.' });
    }

    await settings.update({ proxmox_node, vm_storage });

    console.log('✅ Préférences de stockage mises à jour');
    return res.status(200).json({ message: 'Préférences de stockage mises à jour', settings });
  } catch (err) {
    console.error('❌ Erreur updateStorageSettings:', err);
    return res.status(500).json({ message: 'Erreur serveur.' });
  }
};

exports.createUserSettings = async (req, res) => {
  console.log('📥 createUserSettings called for user', req.user?.id, req.body);
  const userId = req.user?.id;
  const data = req.body;

  try {
    const existing = await UserSetting.findOne({ where: { user_id: userId } });
    if (existing) {
      console.log('⚠️ Paramètres déjà existants');
      return res.status(400).json({ message: 'Les paramètres existent déjà pour cet utilisateur.' });
    }

    const settings = await UserSetting.create({ user_id: userId, ...data });

    console.log('✅ Paramètres créés');
    return res.status(201).json({ message: 'Paramètres créés avec succès', settings });
  } catch (err) {
    console.error('❌ Erreur lors de la création des paramètres :', err);
    return res.status(500).json({ message: 'Erreur serveur.' });
  }
};

exports.listAllSettings = async (req, res) => {
  console.log('📥 listAllSettings called', req.query);
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
        { cloudinit_user: { [Op.iLike]: `%${q}%` } },
        { proxmox_api_url: { [Op.iLike]: `%${q}%` } },
        { proxmox_api_token_id: { [Op.iLike]: `%${q}%` } },
        { proxmox_api_token_name: { [Op.iLike]: `%${q}%` } },
        { pm_user: { [Op.iLike]: `%${q}%` } },
        { proxmox_node: { [Op.iLike]: `%${q}%` } },
      ];
    }
    const { count, rows } = await UserSetting.findAndCountAll({
      where,
      include: [{ model: User, as: 'user', attributes: ['id', 'email'] }],
      order: [[sort, direction]],
      limit,
      offset,
    });
    console.log(`📤 ${rows.length} paramètres trouvés`);
    return res.status(200).json({
      data: rows,
      pagination: {
        total: count,
        page,
        pages: Math.ceil(count / limit),
        limit,
      },
    });
  } catch (err) {
    console.error('❌ Erreur listing settings :', err);
    return res.status(500).json({ message: 'Erreur serveur.' });
  }
};
