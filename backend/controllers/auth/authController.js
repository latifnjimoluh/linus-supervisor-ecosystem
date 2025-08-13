// controllers/auth/authController.js
const bcrypt = require('bcryptjs'); // ✅ préfère bcryptjs en environnements type Render
const db = require('../../models');
const { User, Role } = db;
const { Op } = db.Sequelize;
const { createToken } = require('../../middlewares/auth');
const { sendResetCode } = require('../../utils/mailer');

// Petit helper: jamais laisser un logAction faire échouer la route
async function safeLog(req, action, meta = {}) {
  try {
    const { logAction } = require('../../middlewares/log');
    await logAction(req, action, meta);
  } catch (e) {
    console.error(`[LOGACTION] échec (${action})`, e?.message || e);
  }
}

// ------------------------- REGISTER -------------------------
exports.register = async (req, res) => {
  const start = Date.now();
  try {
    const creator = req.user; // fourni par verifyToken + checkPermission en amont

    const {
      first_name,
      last_name,
      email,
      phone,
      password,
      role_id,
      status,
    } = req.body || {};

    if (!role_id) {
      return res.status(400).json({ message: "Le champ 'role_id' est obligatoire." });
    }
    if (!email || !password) {
      return res.status(400).json({ message: "Email et mot de passe sont requis." });
    }

    const existing = await User.findOne({ where: { email } });
    if (existing) {
      return res.status(400).json({ message: 'Email déjà utilisé.' });
    }

    const role = await Role.findOne({ where: { id: role_id, status: 'actif' } });
    if (!role) {
      return res.status(400).json({ message: 'Rôle introuvable ou inactif.' });
    }

    const creatorRoleName = creator?.role || 'inconnu';
    if (['admin', 'superadmin'].includes(role.name) && creatorRoleName !== 'superadmin') {
      return res.status(403).json({ message: 'Seul un superadmin peut créer ce type de compte.' });
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

    await safeLog(req, `create_user:${user.email}`, { user_id: user.id });

    const ms = Date.now() - start;
    console.log(`[REGISTER] OK ${email} en ${ms}ms`);
    return res.status(201).json({ message: 'Utilisateur créé avec succès', user });
  } catch (err) {
    console.error('[REGISTER] 500', err);
    return res.status(500).json({ message: "Erreur serveur lors de l'enregistrement." });
  }
};

// ------------------------- LOGIN -------------------------
exports.login = async (req, res) => {
  const start = Date.now();
  try {
    const { email, password, remember } = req.body || {};

    if (!email || !password) {
      return res.status(400).json({ message: 'Email et mot de passe sont requis.' });
    }

    if (!process.env.JWT_SECRET) {
      console.error('[LOGIN] JWT_SECRET manquant dans les variables d’environnement');
      return res.status(500).json({ message: 'Configuration JWT manquante.' });
    }

    const user = await User.findOne({
      where: { email },
      include: [{ model: Role, as: 'role', attributes: ['id', 'name', 'status'] }],
    });

    if (!user) {
      return res.status(401).json({ message: 'Email ou mot de passe incorrect.' });
    }

    if (!user.password) {
      console.error('[LOGIN] Hash de mot de passe manquant en base pour', email);
      return res.status(500).json({ message: 'Compte mal configuré (mot de passe absent).' });
    }

    const ok = await bcrypt.compare(password, user.password).catch((e) => {
      console.error('[LOGIN] Erreur bcrypt.compare:', e?.message || e);
      return false;
    });

    if (!ok) {
      return res.status(401).json({ message: 'Email ou mot de passe incorrect.' });
    }

    if (user.status !== 'active') {
      return res.status(403).json({ message: `Compte ${user.status}.` });
    }

    // Optionnel: tu peux aussi bloquer si role inactif
    if (!user.role || user.role.status !== 'actif') {
      return res.status(403).json({ message: 'Rôle inactif ou non autorisé.' });
    }

    // Injecte un req.user minimal pour les logs
    req.user = {
      id: user.id,
      email: user.email,
      role: user.role?.name,
      role_id: user.role_id,
    };

    const token = createToken(
      { id: user.id, email: user.email, role_id: user.role_id },
      remember ? '7d' : (process.env.JWT_EXPIRES_IN || '24h')
    );

    await safeLog(req, 'login', { user_id: user.id });

    const ms = Date.now() - start;
    console.log(`[LOGIN] OK ${email} en ${ms}ms`);

    return res.json({
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
    const ms = Date.now() - start;
    console.error('[LOGIN] 500 en', ms, 'ms ->', err?.message || err);
    return res.status(500).json({ message: 'Erreur lors de la connexion.' });
  }
};

// ------------------------- REQUEST RESET -------------------------
exports.requestReset = async (req, res) => {
  try {
    const { email } = req.body || {};
    if (!email) {
      return res.status(400).json({ message: "L'adresse e-mail est requise." });
    }

    const emailRegex = /^\S+@\S+\.\S+$/;
    if (!emailRegex.test(email)) {
      return res.status(400).json({ message: "Format d'e-mail incorrect." });
    }

    const user = await User.findOne({ where: { email } });

    // On répond toujours "OK" même si user n'existe pas (pas d’info leak)
    if (user) {
      const code = Math.floor(100000 + Math.random() * 900000).toString();
      const expires = new Date(Date.now() + 15 * 60 * 1000);

      user.reset_token = code;
      user.reset_expires_at = expires;
      await user.save();

      try {
        await sendResetCode(email, code);
      } catch (e) {
        console.error('[REQUEST RESET] Erreur mailer:', e?.message || e);
        // On n’échoue pas pour autant ; on peut logguer
      }

      // logAction avec user connu
      req.user = { id: user.id, email: user.email };
      await safeLog(req, 'request_reset_code', { user_id: user.id });
    }

    return res.json({
      message:
        "Si un compte est associé, un code a été envoyé à votre adresse e-mail.",
    });
  } catch (error) {
    console.error('[REQUEST RESET] 500', error?.message || error);
    return res.status(500).json({ message: 'Erreur serveur.' });
  }
};

// ------------------------- RESET PASSWORD -------------------------
exports.resetPassword = async (req, res) => {
  try {
    const { code, password } = req.body || {};
    if (!code || !password) {
      return res.status(400).json({ message: 'Code et nouveau mot de passe sont requis.' });
    }

    const user = await User.findOne({
      where: {
        reset_token: code,
        reset_expires_at: { [Op.gt]: new Date() },
      },
    });

    if (!user) {
      return res.status(400).json({ message: 'Code invalide ou expiré.' });
    }

    const hashed = await bcrypt.hash(password, 10);

    user.password = hashed;
    user.reset_token = null;
    user.reset_expires_at = null;
    user.last_password_reset_at = new Date();
    await user.save();

    req.user = { id: user.id, email: user.email };
    await safeLog(req, 'reset_password', { user_id: user.id });

    return res.json({ message: 'Mot de passe réinitialisé avec succès.' });
  } catch (error) {
    console.error('[RESET PASSWORD] 500', error?.message || error);
    return res.status(500).json({ message: 'Erreur serveur.' });
  }
};

// ------------------------- GET ME -------------------------
exports.getMe = async (req, res) => {
  try {
    const user = await User.findByPk(req.user.id, {
      include: [{ model: Role, as: 'role', attributes: ['id', 'name', 'status'] }],
    });
    if (!user) return res.status(404).json({ message: 'Utilisateur introuvable.' });
    return res.json({
      id: user.id,
      first_name: user.first_name,
      last_name: user.last_name,
      email: user.email,
      role: user.role?.name,
    });
  } catch (err) {
    console.error('[GET ME] 500', err?.message || err);
    return res.status(500).json({ message: 'Erreur lors de la récupération du profil.' });
  }
};

// ------------------------- CHANGE PASSWORD -------------------------
exports.changePassword = async (req, res) => {
  try {
    const { currentPassword, newPassword } = req.body || {};
    if (!currentPassword || !newPassword) {
      return res.status(400).json({ message: 'Champs requis.' });
    }
    if (currentPassword === newPassword) {
      return res.status(400).json({ message: 'Le nouveau mot de passe doit être différent.' });
    }

    const user = await User.findByPk(req.user.id);
    if (!user) return res.status(404).json({ message: 'Utilisateur introuvable.' });

    const ok = await bcrypt.compare(currentPassword, user.password);
    if (!ok) {
      return res.status(400).json({ message: 'Mot de passe actuel invalide.' });
    }

    user.password = await bcrypt.hash(newPassword, 10);
    await user.save();

    await safeLog(req, 'change_password', { user_id: user.id });
    return res.json({ message: 'Mot de passe mis à jour.' });
  } catch (err) {
    console.error('[CHANGE PASSWORD] 500', err?.message || err);
    return res.status(500).json({ message: 'Erreur lors du changement de mot de passe.' });
  }
};

// ------------------------- RESET HISTORY -------------------------
exports.getUsersWithResetHistory = async (req, res) => {
  try {
    const users = await User.findAll({
      where: { last_password_reset_at: { [Op.not]: null } },
      attributes: ['id', 'email', 'first_name', 'last_name', 'last_password_reset_at'],
      order: [['last_password_reset_at', 'DESC']],
    });

    await safeLog(req, 'view_reset_history');
    return res.json(users);
  } catch (error) {
    console.error('[RESET HISTORY] 500', error?.message || error);
    return res.status(500).json({ message: 'Erreur serveur.' });
  }
};
