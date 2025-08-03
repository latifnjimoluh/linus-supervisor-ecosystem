const express = require("express");
const router = express.Router();

const initializationScriptController = require("../../controllers/generate/generateInitializationScriptController");
const { verifyToken, checkPermission } = require("../../middlewares/auth");
const logUserAction = require("../../middlewares/logUserAction");


// 📌 Générer et sauvegarder un script init personnalisé
router.post(
  "/generate",
  verifyToken,
  checkPermission("initializationScript.generate"), // 🔐 Vérification dynamique
  logUserAction("Génération d'un script d'initialisation", req => `Body: ${JSON.stringify(req.body)}`),
  initializationScriptController.generateInitializationScript
);

router.get(
  "/generate",
  verifyToken,
  checkPermission("initializationScript.list"),
  logUserAction("Consultation des scripts d'initialisation"),
  initializationScriptController.listInitializationScripts
);

router.put(
  "/generate/:id",
  verifyToken,
  checkPermission("initializationScript.update"),
  logUserAction("Mise à jour d'un script d'initialisation", req => `ID: ${req.params.id}`),
  initializationScriptController.updateInitializationScript
);

router.delete(
  "/generate/:id",
  verifyToken,
  checkPermission("initializationScript.delete"),
  logUserAction("Suppression d'un script d'initialisation", req => `ID: ${req.params.id}`),
  initializationScriptController.deleteInitializationScript
);

module.exports = router;
