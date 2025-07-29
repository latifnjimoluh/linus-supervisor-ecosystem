const express = require("express");
const router = express.Router();
const controller = require("../controllers/monitoringServiceController");

router.post("/monitoring-services/generate", controller.generateMonitoringServiceScript);

module.exports = router;
