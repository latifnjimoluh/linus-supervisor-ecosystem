const express = require("express");
const router = express.Router();

const initScriptController = require("../../controllers/generate/generateInitScriptController");
const { verifyToken, checkPermission } = require("../../middlewares/auth");
const logUserAction = require("../../middlewares/logUserAction");


// 📌 Générer et sauvegarder un script init personnalisé
router.post(
  "/generate",
  verifyToken,
  checkPermission("initScript.generate"), // 🔐 Vérification dynamique
  logUserAction("Génération d'un script d'initialisation", req => `Body: ${JSON.stringify(req.body)}`),
  initScriptController.generateInitScript
);

router.get(
  "/generate",
  verifyToken,
  checkPermission("initScript.list"),
  logUserAction("Consultation des scripts d'initialisation"),
  initScriptController.listInitScripts
);

router.put(
  "/generate/:id",
  verifyToken,
  checkPermission("initScript.update"),
  logUserAction("Mise à jour d'un script d'initialisation", req => `ID: ${req.params.id}`),
  initScriptController.updateInitScript
);

router.delete(
  "/generate/:id",
  verifyToken,
  checkPermission("initScript.delete"),
  logUserAction("Suppression d'un script d'initialisation", req => `ID: ${req.params.id}`),
  initScriptController.deleteInitScript
);

module.exports = router;
