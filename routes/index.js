const express = require("express");
const router = express.Router();

const authRoutes = require("./authRoutes");
const deployRoutes = require("./deployRoutes");
const configureService = require("./configureRoutes");
const initScriptRoutes = require("./initScriptRoutes");
const monitoringRoutes = require("./monitoring");

router.use("/auth", authRoutes);
router.use("/", deployRoutes);
router.use("/", configureService);
router.use("/init-scripts", initScriptRoutes); 
router.use("/monitoring", monitoringRoutes);

module.exports = router;
