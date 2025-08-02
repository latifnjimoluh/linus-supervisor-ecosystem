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

module.exports = router;
