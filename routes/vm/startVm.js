const express = require("express");
const router = express.Router();
const { startVM } = require("../../controllers/vm/startVMController");
const { verifyToken, checkPermission } = require("../../middlewares/auth");
const logUserAction = require("../../middlewares/logUserAction");

router.post(
  "/start",
  verifyToken,
  checkPermission("vm.start"),
  logUserAction("Démarrage d'une VM", req => `Body: ${JSON.stringify(req.body)}`),
  startVM
);

module.exports = router;
