const express = require("express");
const router = express.Router();
const roleController = require("../../controllers/user/userRoleController");
const { verifyToken, checkPermission } = require("../../middlewares/auth");


router.get("/", verifyToken, checkPermission("roles.read"), roleController.getAllRoles);
router.post("/", verifyToken, checkPermission("roles.create"), roleController.createRole);
router.put("/:id", verifyToken, checkPermission("roles.update"), roleController.updateRole);
router.delete("/:id", verifyToken, checkPermission("roles.delete"), roleController.deleteRole);

module.exports = router;
