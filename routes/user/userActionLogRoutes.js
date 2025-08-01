const express = require("express");
const router = express.Router();
const userActionLogController = require("../../controllers/user/userActionLogController");
const { verifyToken, checkPermission } = require("../../middlewares/auth");


router.get("/users/:id", verifyToken, checkPermission("userLogs.view"), userActionLogController.getLogsByUser);

module.exports = router;
