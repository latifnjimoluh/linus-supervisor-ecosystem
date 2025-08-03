const express = require("express");
const router = express.Router();
const { checkVMStatus } = require("../../controllers/vm/checkVMStatusController");
const { verifyToken, checkPermission } = require("../../middlewares/auth");
const logUserAction = require("../../middlewares/logUserAction");


router.post(
  "/check-vm-status",
  verifyToken,
  checkPermission("vm.status"),
  logUserAction("Vérification de l'état d'une VM", req => `Body: ${JSON.stringify(req.body)}`),
  checkVMStatus
);

module.exports = router;
