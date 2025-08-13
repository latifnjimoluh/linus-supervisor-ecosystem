require('dotenv').config();
const jwt = require('jsonwebtoken');
const { Role, Permission, AssignedPermission } = require('../models');

const secret = process.env.JWT_SECRET;

/**
 * \u{1F512} Création du token
 */
const createToken = (user, expiresIn = process.env.JWT_EXPIRES_IN || '15m') => {
  console.log('🎫 Création du token avec:', user);
  return jwt.sign(
    {
      id: user.id,
      email: user.email,
      role_id: user.role_id,
    },
    secret,
    { expiresIn }
  );
};

/**
 * \u{1F512} Vérification du token et injection du rôle + permissions dans req.user
 */

const verifyToken = async (req, res, next) => {
  try {
    const authHeader = req.headers['authorization'] || req.headers['Authorization'];
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      console.log('🚫 Token absent ou invalide (header manquant ou format incorrect)');
      return res.status(401).json({ message: 'Token manquant ou invalide.' });
    }

    if (!secret) {
      console.error('⚠️ JWT_SECRET manquant dans les variables d’environnement');
      return res.status(500).json({ message: 'Configuration JWT manquante.' });
    }

    const token = authHeader.slice(7);

    // jwt.verify (sync) lève en cas d’expiration / signature invalide
    let decoded;
    try {
      decoded = jwt.verify(token, secret);
    } catch (err) {
      console.log('❌ Token invalide/expiré:', err?.name || err?.message || err);
      const isExpired = err?.name === 'TokenExpiredError';
      return res.status(401).json({ message: isExpired ? 'Session expirée.' : 'Token invalide.' });
    }

    // Récupère le rôle + permissions depuis la BD
    const role = await Role.findByPk(decoded.role_id, {
      include: [{ model: Permission, as: 'permissions', through: { attributes: [] } }],
    });

    if (!role || role.status !== 'actif') {
      console.log('⛔ Rôle inactif ou introuvable:', decoded.role_id);
      return res.status(403).json({ message: 'Rôle invalide ou inactif.' });
    }

    const permissions = (role.permissions || []).map(p => p.name);

    // Injection dans req.user (utilisable par les contrôleurs + logs)
    req.user = {
      id: decoded.id,
      email: decoded.email,
      role_id: decoded.role_id,
      role: role.name,
      permissions,
    };

    console.log('✅ Authentifié avec rôle + permissions:', {
      id: req.user.id,
      email: req.user.email,
      role: req.user.role,
      permissionsCount: permissions.length
    });

    return next();
  } catch (error) {
    console.error('🔥 Erreur verifyToken:', error);
    return res.status(500).json({ message: 'Erreur serveur.' });
  }
};

/**
 * \u{1F9F1} Vérifie si l'utilisateur a au moins un des rôles donnés
 */
const checkRole = (authorizedRoles = []) => {
  return (req, res, next) => {
    if (!authorizedRoles.includes(req.user.role)) {
      return res.status(403).json({ message: '⛔ Accès refusé pour ce rôle.' });
    }
    next();
  };
};

/**
 * ✅ Vérifie si l'utilisateur a une permission donnée (ex: "template.create")
 */
/**
 * \u{1F510} Middleware dynamique basé sur la permission stockée en BDD
 * @param {string} permissionKey - ex: "vm.deploy"
 */
const checkPermission = (permissionKey) => {
  return async (req, res, next) => {
    try {
      const roleId = req.user?.role_id;
      if (!roleId) {
        return res.status(403).json({ message: '⛔ Rôle utilisateur introuvable.' });
      }

      const permission = await Permission.findOne({ where: { key: permissionKey } });
      if (!permission) {
        return res.status(403).json({ message: `⛔ Permission '${permissionKey}' non trouvée.` });
      }

      const rolePermission = await AssignedPermission.findOne({
        where: {
          role_id: roleId,
          permission_id: permission.id,
        },
      });

      if (!rolePermission) {
        return res.status(403).json({ message: `⛔ Accès refusé : permission '${permissionKey}' non accordée.` });
      }

      next();
    } catch (error) {
      console.error('Erreur middleware checkPermission:', error);
      return res.status(500).json({ message: 'Erreur interne serveur (permission).' });
    }
  };
};

/**
 * \u{1F6E1}\u{FE0F} Vérifie que l'utilisateur est superadmin
 */
const isSuperAdmin = (req, res, next) => {
  if (req.user?.role !== 'superadmin') {
    return res.status(403).json({ message: '⛔ Accès réservé aux superadmins.' });
  }
  next();
};

module.exports = {
  createToken,
  verifyToken,
  checkRole,
  checkPermission,
  isSuperAdmin,
};

