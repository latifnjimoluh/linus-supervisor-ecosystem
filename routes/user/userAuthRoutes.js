const express = require("express");
const router = express.Router();
const userAuthController = require("../../controllers/user/userAuthController");
const resetPasswordController = require("../../controllers/user/userResetPasswordController");
const { verifyToken, checkPermission } = require("../../middlewares/auth");
const logUserAction = require("../../middlewares/logUserAction");

router.get(
  "/with-reset-history",
  verifyToken,
  checkPermission("auth.reset.history"),
  resetPasswordController.getUsersWithResetHistory
);

router.post(
  "/reset-password",
  logUserAction("Réinitialisation de mot de passe", req => `Via code: ${req.body.code}`),
  resetPasswordController.resetPassword
);

router.post(
  "/request-reset",
  logUserAction("Demande de réinitialisation", req => `Email: ${req.body.email}`),
  resetPasswordController.requestReset
);

router.post(
  "/register",
  verifyToken,
  checkPermission("auth.register"),
  logUserAction("Création d’un compte utilisateur", req => `Email créé: ${req.body.email}, Rôle ID: ${req.body.role_id}`),
  userAuthController.register
);

router.post(
  "/login",
  logUserAction("Connexion", req => `Email: ${req.body.email}`),
  userAuthController.login
);

module.exports = router;
