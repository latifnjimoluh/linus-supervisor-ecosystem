const express = require("express");
const router = express.Router();

const authRoutes = require("./authRoutes");
const deployRoutes = require("./deployRoutes");
const configureService = require("./configureRoutes");
const monitoringRoutes = require("./monitoring");
const templateRoutes = require("./templateRoutes");
const monitoringServiceRoutes = require("./monitoringServiceRoutes");
const initScriptRoutes = require("./initScripts");
const supervisionRoutes = require("./supervisionRoutes");

router.use("/auth", authRoutes);
router.use("/", deployRoutes);
router.use("/", configureService);
router.use("/monitoring", monitoringRoutes);
router.use("/templates", templateRoutes);
router.use("/", monitoringServiceRoutes);
router.use("/init-scripts", initScriptRoutes);
router.use("/supervision", supervisionRoutes);



module.exports = router;
