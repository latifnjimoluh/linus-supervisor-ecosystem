const express = require("express");
const router = express.Router();
const { checkVMStatus } = require("../../controllers/vm/checkVMStatusController");
const { verifyToken, checkPermission } = require("../../middlewares/auth");


router.post(
  "/check-vm-status",
  verifyToken,
  checkPermission("vm.status"),
  checkVMStatus
);

module.exports = router;
