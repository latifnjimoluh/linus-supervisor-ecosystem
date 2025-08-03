const express = require("express");
const router = express.Router();
const { deleteVMDirect } = require("../../controllers/vm/deleteVMController");
const { verifyToken, checkPermission } = require("../../middlewares/auth");
const logUserAction = require("../../middlewares/logUserAction");


router.post(
  "/delete-vm",
  verifyToken,
  checkPermission("vm.delete"),
  logUserAction("Suppression d'une VM", req => `Body: ${JSON.stringify(req.body)}`),
  deleteVMDirect
);

module.exports = router;
