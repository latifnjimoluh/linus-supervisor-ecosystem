const express = require("express");
const router = express.Router();
const { stopVM } = require("../../controllers/vm/stopVMController");
const { verifyToken, checkPermission } = require("../../middlewares/auth");

router.post(
  "/stop",
  verifyToken,
  checkPermission("vm.stop"),
  stopVM
);

module.exports = router;
