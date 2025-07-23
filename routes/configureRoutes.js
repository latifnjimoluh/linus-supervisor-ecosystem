// 📁 routes/configureRoutes.js
const express = require("express");
const router = express.Router();
const { configureService } = require("../controllers/configureServiceController");
const { verifyToken, checkRole } = require("../middlewares/auth");

router.post("/configure-service", verifyToken, checkRole(["technicien", "superadmin"]), configureService);

module.exports = router;
