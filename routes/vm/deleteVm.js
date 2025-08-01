const express = require("express");
const router = express.Router();
const { deleteVMDirect } = require("../../controllers/vm/deleteVMController");
const { verifyToken, checkPermission } = require("../../middlewares/auth");


router.post(
  "/delete-vm",
  verifyToken,
  checkPermission("vm.delete"),
  deleteVMDirect
);

module.exports = router;
