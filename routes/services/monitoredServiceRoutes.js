const express = require("express");
const router = express.Router();
const controller = require("../../controllers/generate/generateMonitoredServiceController");
const { verifyToken, checkPermission } = require("../../middlewares/auth");
const logUserAction = require("../../middlewares/logUserAction");


router.post(
  "/monitored-services/generate",
  verifyToken,
  checkPermission("monitoredService.generate"),
  logUserAction("Génération d'un script de monitoring de service", req => `Body: ${JSON.stringify(req.body)}`),
  controller.generateMonitoredServiceScript
);

router.get(
  "/monitored-services/generate",
  verifyToken,
  checkPermission("monitoredService.list"),
  logUserAction("Consultation des scripts de monitoring de service"),
  controller.listMonitoredServiceScripts
);

router.put(
  "/monitored-services/generate/:id",
  verifyToken,
  checkPermission("monitoredService.update"),
  logUserAction("Mise à jour d'un script de monitoring de service", req => `ID: ${req.params.id}`),
  controller.updateMonitoredServiceScript
);

router.delete(
  "/monitored-services/generate/:id",
  verifyToken,
  checkPermission("monitoredService.delete"),
  logUserAction("Suppression d'un script de monitoring de service", req => `ID: ${req.params.id}`),
  controller.deleteMonitoredServiceScript
);

module.exports = router;
