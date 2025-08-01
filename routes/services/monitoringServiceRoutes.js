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

module.exports = router;
