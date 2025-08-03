const express = require("express");
const router = express.Router();
const controller = require("../../controllers/generate/generateMonitoringServiceController");
const { verifyToken, checkPermission } = require("../../middlewares/auth");
const logUserAction = require("../../middlewares/logUserAction");


router.post(
  "/monitoring-services/generate",
  verifyToken,
  checkPermission("monitoringService.generate"),
  logUserAction("Génération d'un script de monitoring de service", req => `Body: ${JSON.stringify(req.body)}`),
  controller.generateMonitoringServiceScript
);

router.get(
  "/monitoring-services/generate",
  verifyToken,
  checkPermission("monitoringService.list"),
  logUserAction("Consultation des scripts de monitoring de service"),
  controller.listMonitoringServiceScripts
);

router.put(
  "/monitoring-services/generate/:id",
  verifyToken,
  checkPermission("monitoringService.update"),
  logUserAction("Mise à jour d'un script de monitoring de service", req => `ID: ${req.params.id}`),
  controller.updateMonitoringServiceScript
);

router.delete(
  "/monitoring-services/generate/:id",
  verifyToken,
  checkPermission("monitoringService.delete"),
  logUserAction("Suppression d'un script de monitoring de service", req => `ID: ${req.params.id}`),
  controller.deleteMonitoringServiceScript
);

module.exports = router;
