const express = require("express");
const router = express.Router();
const { deleteVMDirect } = require("../../controllers/vm/deleteVMController");
const { verifyToken, checkRole } = require("../../middlewares/auth");

// 🔐 Route protégée par authentification
router.post("/delete-vm", verifyToken, checkRole(["technicien", "superadmin"]), deleteVMDirect);

module.exports = router;
