const express = require("express");
const router = express.Router();
const {
  generateMonitoringScript,
  listMonitoringScripts,
  updateMonitoringScript,
  deleteMonitoringScript,
} = require("../../controllers/generate/generateMonitoringDNSController");
const { verifyToken, checkPermission } = require("../../middlewares/auth");
const logUserAction = require("../../middlewares/logUserAction");


router.post(
  "/generate",
  verifyToken,
  checkPermission("monitoringScript.generate"),
  logUserAction("Génération d'un script de monitoring DNS", req => `Body: ${JSON.stringify(req.body)}`),
  generateMonitoringScript
);

router.get(
  "/generate",
  verifyToken,
  checkPermission("monitoringScript.list"),
  logUserAction("Consultation des scripts de monitoring DNS"),
  listMonitoringScripts
);

router.put(
  "/generate/:id",
  verifyToken,
  checkPermission("monitoringScript.update"),
  logUserAction("Mise à jour d'un script de monitoring DNS", req => `ID: ${req.params.id}`),
  updateMonitoringScript
);

router.delete(
  "/generate/:id",
  verifyToken,
  checkPermission("monitoringScript.delete"),
  logUserAction("Suppression d'un script de monitoring DNS", req => `ID: ${req.params.id}`),
  deleteMonitoringScript
);

module.exports = router;
