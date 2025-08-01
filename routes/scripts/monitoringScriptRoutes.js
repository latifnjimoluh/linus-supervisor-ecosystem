const express = require("express");
const router = express.Router();
const { generateMonitoringScript } = require("../../controllers/scripts/monitoringScriptController");
const { verifyToken, checkPermission } = require("../../middlewares/auth");


router.post(
  "/generate",
  verifyToken,
  checkPermission("monitoringScript.generate"),
  generateMonitoringScript
);

module.exports = router;
