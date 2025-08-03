const express = require("express");
const router = express.Router();
const userActivityLogController = require("../../controllers/user/userActivityLogController");
const { verifyToken, checkPermission } = require("../../middlewares/auth");
const logUserAction = require("../../middlewares/logUserAction");

router.get(
  "/",
  verifyToken,
  checkPermission("userActivityLogs.view"),
  logUserAction("Consultation de tous les logs d'utilisateur"),
  userActivityLogController.getAllLogs
);
router.get(
  "/users/:id",
  verifyToken,
  checkPermission("userActivityLogs.view"),
  logUserAction("Consultation des logs d'un utilisateur", req => `ID: ${req.params.id}`),
  userActivityLogController.getLogsByUser
);

module.exports = router;
