const express = require("express");
const router = express.Router();
const { stopVM } = require("../../controllers/vm/stopVMController");
const { verifyToken, checkPermission } = require("../../middlewares/auth");
const logUserAction = require("../../middlewares/logUserAction");

router.post(
  "/stop",
  verifyToken,
  checkPermission("vm.stop"),
  logUserAction("Arrêt d'une VM", req => `Body: ${JSON.stringify(req.body)}`),
  stopVM
);

module.exports = router;
