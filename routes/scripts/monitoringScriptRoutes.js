const express = require("express");
const router = express.Router();
const {
  generateMonitoringScript,
  listMonitoringScripts,
  updateMonitoringScript,
  deleteMonitoringScript,
} = require("../../controllers/generate/generateMonitoringDNSController");
const { verifyToken, checkPermission } = require("../../middlewares/auth");


router.post(
  "/generate",
  verifyToken,
  checkPermission("monitoringScript.generate"),
  generateMonitoringScript
);

router.get(
  "/generate",
  verifyToken,
  checkPermission("monitoringScript.list"),
  listMonitoringScripts
);

router.put(
  "/generate/:id",
  verifyToken,
  checkPermission("monitoringScript.update"),
  updateMonitoringScript
);

router.delete(
  "/generate/:id",
  verifyToken,
  checkPermission("monitoringScript.delete"),
  deleteMonitoringScript
);

module.exports = router;
