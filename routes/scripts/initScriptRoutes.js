const express = require("express");
const router = express.Router();

const initScriptController = require("../../controllers/generate/generateInitScriptController");
const { verifyToken, checkPermission } = require("../../middlewares/auth");


// 📌 Générer et sauvegarder un script init personnalisé
router.post(
  "/generate",
  verifyToken,
  checkPermission("initScript.generate"), // 🔐 Vérification dynamique
  initScriptController.generateInitScript
);

router.get(
  "/generate",
  verifyToken,
  checkPermission("initScript.list"),
  initScriptController.listInitScripts
);

router.put(
  "/generate/:id",
  verifyToken,
  checkPermission("initScript.update"),
  initScriptController.updateInitScript
);

router.delete(
  "/generate/:id",
  verifyToken,
  checkPermission("initScript.delete"),
  initScriptController.deleteInitScript
);

module.exports = router;
