const express = require("express");
const router = express.Router();

const authRoutes = require("./authRoutes");
const deployRoutes = require("./deployRoutes");

router.use("/auth", authRoutes);
router.use("/", deployRoutes);

module.exports = router;
