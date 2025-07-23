const express = require("express");
const router = express.Router();

const authRoutes = require("./authRoutes");
const deployRoutes = require("./deployRoutes");
const configureService = require("./configureRoutes");

router.use("/auth", authRoutes);
router.use("/", deployRoutes);
router.use("/", configureService);

module.exports = router;
