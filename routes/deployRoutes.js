const express = require("express");
const router = express.Router();
const deployController = require("../controllers/deployController");
const { verifyToken, checkRole } = require("../middlewares/auth");

router.post("/deploy", verifyToken, checkRole(["technicien", "superadmin"]), deployController.deployInfrastructure);

router.post("/destroy", verifyToken, checkRole(["technicien", "superadmin"]), deployController.destroyInfrastructure);

module.exports = router;
