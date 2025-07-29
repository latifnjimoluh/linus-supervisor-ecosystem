const express = require("express");
const router = express.Router();

const initScriptController = require("../controllers/initScriptController");

// 📌 Générer et sauvegarder un script init personnalisé
router.post("/generate", initScriptController.generateInitScript);

module.exports = router;
