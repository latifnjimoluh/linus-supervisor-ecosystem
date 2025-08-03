const express = require("express");
const router = express.Router();
const deployVMDirect = require("../../controllers/vm/deployVMController");
const { verifyToken, checkPermission } = require("../../middlewares/auth");
const logUserAction = require("../../middlewares/logUserAction");


router.post(
  "/deploy-vm",
  verifyToken,
  checkPermission("vm.deploy"),
  logUserAction("Déploiement d'une VM", req => `Body: ${JSON.stringify(req.body)}`),
  deployVMDirect.deployVMDirect
);

module.exports = router;
