// 📁 routes/services/serviceConfigRoutes.js
const express = require("express");
const router = express.Router();
const { configureService } = require("../../controllers/services/configureServiceController");
const { verifyToken, checkRole } = require("../../middlewares/auth");

router.post("/configure-service", verifyToken, checkRole(["technicien", "superadmin"]), configureService);

module.exports = router;
