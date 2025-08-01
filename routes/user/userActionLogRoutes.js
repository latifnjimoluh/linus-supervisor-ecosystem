const express = require("express");
const router = express.Router();
const userActionLogController = require("../../controllers/user/userActionLogController");
const { verifyToken } = require("../../middlewares/auth");

router.get("/users/:id", verifyToken, userActionLogController.getLogsByUser);

module.exports = router;
