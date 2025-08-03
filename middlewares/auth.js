require("dotenv").config();
const jwt = require("jsonwebtoken");
const { Role, Permission, AssignedPermission } = require("../models");

const secret = process.env.JWT_SECRET;

/**
 * 🔐 Création du token
 */
const createToken = (user, expiresIn = process.env.JWT_EXPIRES_IN || "1h") => {
  console.log("🎫 Création du token avec:", user);
  return jwt.sign({
    id: user.id,
    email: user.email,
    role_id: user.role_id,
  }, secret, { expiresIn });
};

/**
 * 🔒 Vérification du token et injection du rôle + permissions dans req.user
 */
const verifyToken = async (req, res, next) => {
  const authHeader = req.headers["authorization"];
  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    console.log("🚫 Token absent ou invalide");
    return res.status(401).json({ message: "Token manquant ou invalide." });
  }

  const token = authHeader.split(" ")[1];

  jwt.verify(token, secret, async (err, decoded) => {
    if (err) {
      console.log("❌ Token invalide:", err);
      return res.status(403).json({ message: "Token invalide." });
    }

    try {
      const role = await Role.findByPk(decoded.role_id, {
        include: [{ model: Permission, as: "permissions" }]
      });

      if (!role || role.status !== "actif") {
        console.log("⛔ Rôle inactif ou introuvable:", decoded.role_id);
        return res.status(403).json({ message: "Rôle invalide ou inactif." });
      }

      const permissions = role.permissions.map(p => p.name);

      req.user = {
        id: decoded.id,
        email: decoded.email,
        role_id: decoded.role_id,
        role: role.name,
        permissions, // ⬅️ Injection des permissions
      };

      console.log("✅ Authentifié avec rôle + permissions:", req.user);
      next();
    } catch (error) {
      console.error("🔥 Erreur verifyToken:", error);
      return res.status(500).json({ message: "Erreur serveur." });
    }
  });
};

/**
 * 🧱 Vérifie si l'utilisateur a au moins un des rôles donnés
 */
const checkRole = (authorizedRoles = []) => {
  return (req, res, next) => {
    if (!authorizedRoles.includes(req.user.role)) {
      return res.status(403).json({ message: "⛔ Accès refusé pour ce rôle." });
    }
    next();
  };
};

/**
 * ✅ Vérifie si l'utilisateur a une permission donnée (ex: "template.create")
 */
/**
 * 🔐 Middleware dynamique basé sur la permission stockée en BDD
 * @param {string} permissionKey - ex: "vm.deploy"
 */
const checkPermission = (permissionKey) => {
  return async (req, res, next) => {
    try {
      const roleId = req.user?.role_id;
      if (!roleId) {
        return res.status(403).json({ message: "⛔ Rôle utilisateur introuvable." });
      }

      const permission = await Permission.findOne({ where: { name: permissionKey } });
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
      console.error("Erreur middleware checkPermission:", error);
      return res.status(500).json({ message: "Erreur interne serveur (permission)." });
    }
  };
};

/**
 * 🛡️ Vérifie que l'utilisateur est superadmin
 */
const isSuperAdmin = (req, res, next) => {
  if (req.user?.role !== "superadmin") {
    return res.status(403).json({ message: "⛔ Accès réservé aux superadmins." });
  }
  next();
};

module.exports = {
  createToken,
  verifyToken,
  checkRole,
  checkPermission, // ✅ nouveau middleware
  isSuperAdmin,
};
