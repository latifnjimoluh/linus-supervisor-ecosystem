const express = require("express");
const router = express.Router();
const { startVM } = require("../../controllers/vm/startVMController");
const { verifyToken, checkPermission } = require("../../middlewares/auth");

router.post(
  "/start",
  verifyToken,
  checkPermission("vm.start"),
  startVM
);

module.exports = router;
