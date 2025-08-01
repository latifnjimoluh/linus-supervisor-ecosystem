const express = require("express");
const router = express.Router();
const deployVMDirect = require("../../controllers/vm/deployVMController");
const { verifyToken, checkPermission } = require("../../middlewares/auth");


router.post(
  "/deploy-vm",
  verifyToken,
  checkPermission("vm.deploy"),
  deployVMDirect.deployVMDirect
);

module.exports = router;
