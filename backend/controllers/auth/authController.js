// controllers/auth/authController.js
const bcrypt = require('bcryptjs'); // ✅ préfère bcryptjs en environnements type Render
const jwt = require('jsonwebtoken');
const { randomUUID } = require('crypto');
const db = require('../../models');
const { User, Role, RefreshToken } = db;
const { Op } = db.Sequelize;
const { createToken } = require('../../middlewares/auth');
const { sendResetCode } = require('../../utils/mailer');
const speakeasy = require('speakeasy');
const qrcode = require('qrcode');

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
      status: status || 'actif',
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
    const { email, password, remember, device_id, otp } = req.body || {};

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

    if (user.status !== 'actif') {
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

    if (user.two_factor_enabled && !otp) {
      return res.status(206).json({ message: 'Code 2FA requis.' });
    }

    if (user.two_factor_enabled && otp) {
      const verifiedOtp = speakeasy.totp.verify({
        secret: user.two_factor_secret,
        encoding: 'base32',
        token: otp,
      });
      if (!verifiedOtp) {
        return res.status(401).json({ message: 'Code 2FA invalide.' });
      }
    }

    const token = createToken(
      { id: user.id, email: user.email, role_id: user.role_id },
      process.env.JWT_EXPIRES_IN || '15m'
    );

    let refreshToken;
    let finalDeviceId = device_id;
    if (remember) {
      const jti = randomUUID();
      const payload = { id: user.id, email: user.email, role_id: user.role_id, device_id: finalDeviceId };
      refreshToken = jwt.sign(payload, process.env.JWT_SECRET, {
        expiresIn: process.env.JWT_REFRESH_EXPIRES_IN || '7d',
        jwtid: jti,
      });
      const decoded = jwt.decode(refreshToken);
      const expiresAt = decoded && decoded.exp ? new Date(decoded.exp * 1000) : new Date(Date.now() + 7 * 24 * 60 * 60 * 1000);
      if (!finalDeviceId) {
        finalDeviceId = randomUUID();
      }
      await RefreshToken.create({
        jti,
        user_id: user.id,
        device_id: finalDeviceId,
        expires_at: expiresAt,
      });
    }

    await safeLog(req, 'login', { user_id: user.id });

    const ms = Date.now() - start;
    console.log(`[LOGIN] OK ${email} en ${ms}ms`);

    const response = {
      message: 'Connexion réussie',
      token,
      user: {
        id: user.id,
        first_name: user.first_name,
        last_name: user.last_name,
        email: user.email,
        role: user.role?.name,
      },
    };
    if (refreshToken) {
      response.refreshToken = refreshToken;
      response.device_id = finalDeviceId;
    }
    return res.json(response);
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

// ------------------------- LOGOUT -------------------------
exports.logout = async (req, res) => {
  try {
    const { refreshToken } = req.body || {};
    if (refreshToken) {
      try {
        const decoded = jwt.verify(refreshToken, process.env.JWT_SECRET);
        await RefreshToken.update({ revoked: true }, { where: { jti: decoded.jti } });
      } catch (e) {
        console.error('[LOGOUT] refresh invalide', e?.message || e);
      }
    }
    await safeLog(req, 'logout', { user_id: req.user?.id });
    return res.json({ message: 'Déconnexion réussie' });
  } catch (err) {
    console.error('[LOGOUT] 500', err?.message || err);
    return res.status(500).json({ message: 'Erreur lors de la déconnexion.' });
  }
};

exports.refresh = async (req, res) => {
  try {
    const { refreshToken, device_id } = req.body || {};
    if (!refreshToken || !device_id) {
      return res.status(400).json({ message: 'Refresh token ou device_id manquant.' });
    }
    const decoded = jwt.verify(refreshToken, process.env.JWT_SECRET);
    if (decoded.device_id !== device_id) {
      return res.status(401).json({ message: 'Device non reconnu.' });
    }
    const stored = await RefreshToken.findOne({
      where: { jti: decoded.jti, user_id: decoded.id, device_id, revoked: false },
    });
    if (!stored) {
      return res.status(401).json({ message: 'Refresh token invalide.' });
    }
    if (new Date(stored.expires_at) < new Date()) {
      return res.status(401).json({ message: 'Refresh token expiré.' });
    }
    const token = createToken({
      id: decoded.id,
      email: decoded.email,
      role_id: decoded.role_id,
    });
    return res.json({ token });
  } catch (err) {
    console.error('[REFRESH] échec', err?.message || err);
    return res.status(401).json({ message: 'Échec du rafraîchissement.' });
  }
};

// ------------------------- 2FA SETUP -------------------------
exports.setup2FA = async (req, res) => {
  try {
    const user = await User.findByPk(req.user.id);
    if (!user) {
      return res.status(404).json({ message: 'Utilisateur introuvable.' });
    }
    const secret = speakeasy.generateSecret({ name: `Linusupervisor (${user.email})` });
    user.two_factor_secret = secret.base32;
    user.two_factor_enabled = false;
    await user.save();
    const qr = await qrcode.toDataURL(secret.otpauth_url);
    return res.json({ secret: secret.base32, qr });
  } catch (err) {
    console.error('[2FA setup] 500', err?.message || err);
    return res.status(500).json({ message: 'Erreur lors de la génération du secret 2FA.' });
  }
};

// ------------------------- 2FA VERIFY -------------------------
exports.verify2FA = async (req, res) => {
  try {
    const { token } = req.body || {};
    const user = await User.findByPk(req.user.id);
    if (!user || !user.two_factor_secret) {
      return res.status(400).json({ message: '2FA non configurée.' });
    }
    const verified = speakeasy.totp.verify({
      secret: user.two_factor_secret,
      encoding: 'base32',
      token,
    });
    if (!verified) {
      return res.status(400).json({ message: 'Code 2FA invalide.' });
    }
    user.two_factor_enabled = true;
    await user.save();
    return res.json({ message: '2FA activée.' });
  } catch (err) {
    console.error('[2FA verify] 500', err?.message || err);
    return res.status(500).json({ message: 'Erreur lors de la vérification du code 2FA.' });
  }
};

// ------------------------- 2FA DISABLE -------------------------
exports.disable2FA = async (req, res) => {
  try {
    const user = await User.findByPk(req.user.id);
    if (!user) {
      return res.status(404).json({ message: 'Utilisateur introuvable.' });
    }
    user.two_factor_secret = null;
    user.two_factor_enabled = false;
    await user.save();
    return res.json({ message: '2FA désactivée.' });
  } catch (err) {
    console.error('[2FA disable] 500', err?.message || err);
    return res.status(500).json({ message: 'Erreur lors de la désactivation du 2FA.' });
  }
};
