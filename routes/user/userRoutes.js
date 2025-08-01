const express = require("express");
const router = express.Router();
const userController = require("../../controllers/user/userController");
const { verifyToken, isSuperAdmin } = require("../../middlewares/auth");

// 📋 Lister tous les utilisateurs
router.get("/", verifyToken, userController.getAllUsers);

// 🔍 Voir un utilisateur par ID
router.get("/:id", verifyToken, userController.getUserById);

// ✏️ Modifier un utilisateur
router.put("/:id", verifyToken, userController.updateUser);

// ❌ Suppression logique
router.delete("/:id", verifyToken, isSuperAdmin, userController.softDeleteUser);

module.exports = router;
