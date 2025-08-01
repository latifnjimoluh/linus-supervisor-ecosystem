const express = require("express");
const router = express.Router();
const userController = require("../../controllers/user/userController");
const { verifyToken, checkPermission } = require("../../middlewares/auth");


router.get("/", verifyToken, checkPermission("users.read"), userController.getAllUsers);
router.get("/:id", verifyToken, checkPermission("users.read"), userController.getUserById);
router.put("/:id", verifyToken, checkPermission("users.update"), userController.updateUser);
router.delete("/:id", verifyToken, checkPermission("users.delete"), userController.softDeleteUser);

module.exports = router;
