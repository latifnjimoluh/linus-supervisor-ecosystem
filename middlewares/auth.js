require("dotenv").config();
const jwt = require("jsonwebtoken");
const { Role } = require("../models");

const secret = process.env.JWT_SECRET;

/**
 * 🔐 Génération du token avec l'id, l'email et le role_id
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
 * 🔒 Middleware pour vérifier le token et injecter les infos utilisateur + rôle depuis la base
 */
const verifyToken = async (req, res, next) => {
  const authHeader = req.headers["authorization"];
  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    console.log("🚫 Token absent ou invalide dans l'en-tête");
    return res.status(401).json({ message: "Token manquant ou invalide." });
  }

  const token = authHeader.split(" ")[1];
  jwt.verify(token, secret, async (err, decoded) => {
    if (err) {
      console.log("❌ Token invalide:", err);
      return res.status(403).json({ message: "Token invalide." });
    }

    console.log("🔍 Décodé depuis JWT:", decoded);

    try {
      const role = await Role.findByPk(decoded.role_id);
      if (!role || role.status !== "actif") {
        console.log("⛔ Rôle inactif ou introuvable dans verifyToken:", decoded.role_id);
        return res.status(403).json({ message: "Rôle invalide ou inactif." });
      }

      req.user = {
        id: decoded.id,
        email: decoded.email,
        role_id: decoded.role_id,
        role: role.name,
      };

      console.log("✅ Token validé. Utilisateur injecté:", req.user);
      next();
    } catch (error) {
      console.error("🔥 Erreur lors de la vérification du rôle:", error);
      return res.status(500).json({ message: "Erreur serveur lors de la vérification du rôle." });
    }
  });
};

/**
 * 🧱 Middleware de contrôle d'accès par rôle
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
 * 🛡️ Middleware spécifique pour superadmin uniquement
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
  isSuperAdmin,
};
