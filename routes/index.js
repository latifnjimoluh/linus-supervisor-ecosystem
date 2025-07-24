const express = require("express");
const router = express.Router();

const authRoutes = require("./authRoutes");
const deployRoutes = require("./deployRoutes");
const configureService = require("./configureRoutes");
const initScriptRoutes = require("./initScriptRoutes"); // ✅ nouveau

router.use("/auth", authRoutes);
router.use("/", deployRoutes);
router.use("/", configureService);
router.use("/init-scripts", initScriptRoutes); // ✅ ajout ici

module.exports = router;
