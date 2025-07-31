const express = require("express");
const router = express.Router();
const { checkVMStatus } = require("../../controllers/vm/checkVMStatusController");
const { verifyToken, checkRole } = require("../../middlewares/auth");

router.post("/check-vm-status", verifyToken, checkRole(["technicien", "superadmin"]), checkVMStatus);


module.exports = router;
