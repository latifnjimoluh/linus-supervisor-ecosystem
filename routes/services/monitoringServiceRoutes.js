const express = require("express");
const router = express.Router();
const controller = require("../../controllers/generate/generateMonitoringServiceController");
const { verifyToken, checkPermission } = require("../../middlewares/auth");


router.post(
  "/monitoring-services/generate",
  verifyToken,
  checkPermission("monitoringService.generate"),
  controller.generateMonitoringServiceScript
);

router.get(
  "/monitoring-services/generate",
  verifyToken,
  checkPermission("monitoringService.list"),
  controller.listMonitoringServiceScripts
);

router.put(
  "/monitoring-services/generate/:id",
  verifyToken,
  checkPermission("monitoringService.update"),
  controller.updateMonitoringServiceScript
);

router.delete(
  "/monitoring-services/generate/:id",
  verifyToken,
  checkPermission("monitoringService.delete"),
  controller.deleteMonitoringServiceScript
);

module.exports = router;
