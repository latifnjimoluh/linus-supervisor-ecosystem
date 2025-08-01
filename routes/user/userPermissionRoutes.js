// 📁 routes/permissions/permissionRoutes.js
const express = require("express");
const router = express.Router();
const permissionController = require("../../controllers/user/userPermissionController");
const { verifyToken, isSuperAdmin } = require("../../middlewares/auth");

// 🔐 Routes protégées (superadmin uniquement pour modifications)
router.get("/", verifyToken, permissionController.getAllPermissions);
router.post("/", verifyToken, isSuperAdmin, permissionController.createPermission);
router.post("/assign", verifyToken, isSuperAdmin, permissionController.assignPermissionsToRole);
router.get("/role/:role_id", verifyToken, permissionController.getPermissionsByRole);

module.exports = router;
