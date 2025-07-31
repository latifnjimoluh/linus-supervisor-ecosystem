const express = require("express");
const router = express.Router();
const deployVMDirect = require("../../controllers/vm/deployVMController");
const { verifyToken, checkRole } = require("../../middlewares/auth");

router.post("/deploy-vm", verifyToken, checkRole(["technicien", "superadmin"]), deployVMDirect.deployVMDirect);

module.exports = router;
