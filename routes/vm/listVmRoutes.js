const express = require("express");
const router = express.Router();
const { listDeployed, listDestroyed } = require("../../controllers/vm/listVMController");
const { verifyToken, checkPermission } = require("../../middlewares/auth");
const logUserAction = require("../../middlewares/logUserAction");

router.get(
  "/deployed",
  verifyToken,
  checkPermission("vm.list"),
  logUserAction("Liste des VM déployées"),
  listDeployed
);
router.get(
  "/destroyed",
  verifyToken,
  checkPermission("vm.list"),
  logUserAction("Liste des VM détruites"),
  listDestroyed
);

module.exports = router;
