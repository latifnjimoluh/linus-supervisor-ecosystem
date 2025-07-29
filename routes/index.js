const express = require("express");
const router = express.Router();

const authRoutes = require("./auth/authRoutes");
const deployRoutes = require("./deploy/deployRoutes");
const configureService = require("./services/serviceConfigRoutes");
const monitoringRoutes = require("./scripts/monitoringScriptRoutes");
const templateRoutes = require("./services/serviceTemplateRoutes");
const monitoringServiceRoutes = require("./services/monitoringServiceRoutes");
const initScriptRoutes = require("./scripts/initScriptRoutes");
const supervisionRoutes = require("./supervision/supervisionRoutes");

router.use("/auth", authRoutes);
router.use("/", deployRoutes);
router.use("/", configureService);
router.use("/monitoring", monitoringRoutes);
router.use("/templates", templateRoutes);
router.use("/", monitoringServiceRoutes);
router.use("/init-scripts", initScriptRoutes);
router.use("/supervision", supervisionRoutes);



module.exports = router;
