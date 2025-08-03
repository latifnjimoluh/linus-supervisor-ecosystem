const express = require("express");
const router = express.Router();
const { listDeployed, listDestroyed } = require("../../controllers/vm/listVMController");
const { verifyToken, checkPermission } = require("../../middlewares/auth");

router.get("/deployed", verifyToken, checkPermission("vm.list"), listDeployed);
router.get("/destroyed", verifyToken, checkPermission("vm.list"), listDestroyed);

module.exports = router;
