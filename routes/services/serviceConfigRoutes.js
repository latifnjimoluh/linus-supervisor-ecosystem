// 📁 routes/services/serviceConfigRoutes.js
const express = require("express");
const router = express.Router();
const { configureService } = require("../../controllers/services/configTemplateServiceController");
const { verifyToken, checkRole } = require("../../middlewares/auth");

router.post("/config-template", verifyToken, checkRole(["technicien", "superadmin"]), configureService);

module.exports = router;
