const express = require("express");
const router = express.Router();
const userActionLogController = require("../../controllers/user/userActionLogController");
const { verifyToken, checkPermission } = require("../../middlewares/auth");
const logUserAction = require("../../middlewares/logUserAction");

router.get(
  "/",
  verifyToken,
  checkPermission("userLogs.view"),
  logUserAction("Consultation de tous les logs d'utilisateur"),
  userActionLogController.getAllLogs
);
router.get(
  "/users/:id",
  verifyToken,
  checkPermission("userLogs.view"),
  logUserAction("Consultation des logs d'un utilisateur", req => `ID: ${req.params.id}`),
  userActionLogController.getLogsByUser
);

module.exports = router;
