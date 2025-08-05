const bcrypt = require('bcrypt');
const db = require('../models');
const { User, Role } = db;
const { createToken } = require('../middlewares/auth');
const { logAction } = require('../middlewares/log');
const { sendResetCode } = require('../utils/mailer');

// 📘 Controller d'inscription
exports.register = async (req, res) => {
  try {
    console.log('📥 Requête reçue (register):', req.body);
    const creator = req.user;

    const {
      first_name,
      last_name,
      email,
      phone,
      password,
      role_id,
      status,
    } = req.body;

    // 💥 Vérifier que role_id est fourni
    if (!role_id) {
      console.log('❌ Aucun role_id fourni');
      return res.status(400).json({ message: "Le champ 'role_id' est obligatoire." });
    }

    // 🔍 Vérification unicité email
    const existing = await User.findOne({ where: { email } });
    if (existing) {
      console.log('⚠️ Email déjà utilisé:', email);
      return res.status(400).json({ message: 'Email déjà utilisé.' });
    }

    // 🔐 Vérification du rôle
    const role = await Role.findOne({ where: { id: role_id, status: 'actif' } });
    if (!role) {
      console.log('❌ Rôle introuvable ou inactif:', role_id);
      return res.status(400).json({ message: 'Rôle introuvable ou inactif.' });
    }

    console.log('✅ Rôle récupéré:', role.name);
    const creatorRoleName = creator?.role || 'inconnu';
    console.log('🔐 Rôle du créateur:', creatorRoleName);

    if ([ 'admin', 'superadmin' ].includes(role.name) && creatorRoleName !== 'superadmin') {
      console.log('⛔ Tentative non autorisée de créer un compte sensible');
      return res.status(403).json({ message: '⛔ Seul un superadmin peut créer ce type de compte.' });
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

    console.log('✅ Utilisateur créé avec succès:', user.email);
    await logAction(req, `create_user:${user.email}`, { user_id: user.id });
    res.status(201).json({ message: '✅ Utilisateur créé avec succès', user });
  } catch (err) {
    console.error('🔥 Erreur serveur dans register:', err);
    res.status(500).json({ message: "Erreur serveur lors de l'enregistrement." });
  }
};

// 🔐 Controller de connexion
exports.login = async (req, res) => {
  try {
    console.log('🔐 Tentative de connexion:', req.body.email);
    const { email, password } = req.body;

    const user = await User.findOne({
      where: { email },
      include: [{ model: Role, as: 'role' }],
    });

    if (!user) {
      console.log('❌ Utilisateur introuvable');
      return res.status(401).json({ message: 'Email ou mot de passe incorrect.' });
    }

    const match = await bcrypt.compare(password, user.password);
    if (!match) {
      console.log('❌ Mot de passe invalide pour:', email);
      return res.status(401).json({ message: 'Email ou mot de passe incorrect.' });
    }

    if (user.status !== 'active') {
      console.log('⛔ Compte non actif:', user.status);
      return res.status(403).json({ message: `Compte ${user.status}.` });
    }

    console.log('✅ Connexion réussie. Rôle chargé:', user.role?.name);

    // 🧩 Injection manuelle pour permettre logUserAction de fonctionner
    req.user = {
      id: user.id,
      email: user.email,
      role: user.role?.name,
      role_id: user.role_id,
    };

    const token = createToken({
      id: user.id,
      email: user.email,
      role_id: user.role?.id,
    });

    await logAction(req, 'login', { user_id: user.id });

    res.json({
      message: 'Connexion réussie',
      token,
      user: {
        id: user.id,
        first_name: user.first_name,
        last_name: user.last_name,
        email: user.email,
        role: user.role?.name,
      },
    });
  } catch (err) {
    console.error('🔥 Erreur dans login:', err);
    res.status(500).json({ message: 'Erreur lors de la connexion.' });
  }
};

// 📤 Demande de code de réinitialisation
exports.requestReset = async (req, res) => {
  try {
    console.log('📧 Demande de reset pour:', req.body.email);
    const { email } = req.body;
    if (!email) {
      console.log('❌ Email requis');
      return res.status(400).json({ message: 'Email requis' });
    }

    const user = await User.findOne({ where: { email } });
    if (!user) {
      console.log('❌ Utilisateur introuvable');
      return res.status(404).json({ message: 'Utilisateur introuvable' });
    }

    const code = Math.floor(100000 + Math.random() * 900000).toString();
    const expires = new Date(Date.now() + 15 * 60 * 1000);

    user.reset_token = code;
    user.reset_expires_at = expires;
    await user.save();

    await sendResetCode(email, code);

    req.user = { id: user.id };
    await logAction(req, 'request_reset_code', { user_id: user.id });

    res.json({ message: 'Code envoyé par email' });
  } catch (error) {
    console.error('🔥 Erreur requestReset:', error);
    res.status(500).json({ message: 'Erreur serveur.' });
  }
};

// 🔁 Réinitialisation du mot de passe
exports.resetPassword = async (req, res) => {
  try {
    console.log('🔁 Reset avec code:', req.body.code);
    const { code, password } = req.body;
    if (!code || !password) {
      console.log('❌ Champs requis');
      return res.status(400).json({ message: 'Champs requis' });
    }

    const user = await User.findOne({
      where: {
        reset_token: code,
        reset_expires_at: { [db.Sequelize.Op.gt]: new Date() },
      },
    });

    if (!user) {
      console.log('❌ Code invalide ou expiré');
      return res.status(400).json({ message: 'Code invalide ou expiré' });
    }

    const hashed = await bcrypt.hash(password, 10);

    user.password = hashed;
    user.reset_token = null;
    user.reset_expires_at = null;
    user.last_password_reset_at = new Date();
    await user.save();

    req.user = { id: user.id };
    await logAction(req, 'reset_password', { user_id: user.id });

    res.json({ message: 'Mot de passe réinitialisé avec succès' });
  } catch (error) {
    console.error('🔥 Erreur resetPassword:', error);
    res.status(500).json({ message: 'Erreur serveur.' });
  }
};

// 📜 Historique des réinitialisations
exports.getUsersWithResetHistory = async (req, res) => {
  try {
    console.log('📜 Récupération historique reset');
    const users = await User.findAll({
      where: { last_password_reset_at: { [db.Sequelize.Op.not]: null } },
      attributes: ['id', 'email', 'first_name', 'last_name', 'last_password_reset_at'],
      order: [['last_password_reset_at', 'DESC']],
    });

    await logAction(req, 'view_reset_history');

    res.json(users);
  } catch (error) {
    console.error('Erreur récupération des utilisateurs avec reset:', error);
    res.status(500).json({ message: 'Erreur serveur.' });
  }
};

