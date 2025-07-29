const express = require("express");
const router = express.Router();
const { generateMonitoringScript } = require("../../controllers/scripts/monitoringScriptController");

router.post("/generate", generateMonitoringScript);

module.exports = router;
