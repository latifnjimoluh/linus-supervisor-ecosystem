const express = require("express");
const router = express.Router();
const userSettingsController = require("../../controllers/user/userSettingsController");
const { verifyToken, checkPermission } = require("../../middlewares/auth");
const logUserAction = require("../../middlewares/logUserAction");


router.get(
  "/",
  verifyToken,
  checkPermission("userSettings.read"),
  logUserAction("Consultation des paramètres utilisateur"),
  userSettingsController.getUserSettings
);
router.get(
  "/all",
  verifyToken,
  checkPermission("userSettings.list"),
  logUserAction("Liste de tous les paramètres utilisateur"),
  userSettingsController.listAllSettings
);
router.patch(
  "/",
  verifyToken,
  checkPermission("userSettings.update"),
  logUserAction("Mise à jour des paramètres utilisateur", req => `Body: ${JSON.stringify(req.body)}`),
  userSettingsController.updateUserSettings
);
router.post(
  "/",
  verifyToken,
  checkPermission("userSettings.create"),
  logUserAction("Création de paramètres utilisateur", req => `Body: ${JSON.stringify(req.body)}`),
  userSettingsController.createUserSettings
);

module.exports = router;
