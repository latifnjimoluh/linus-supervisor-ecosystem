// 📁 routes/permissions/permissionRoutes.js
const express = require("express");
const router = express.Router();
const permissionController = require("../../controllers/user/userPermissionController");
const { verifyToken, isSuperAdmin } = require("../../middlewares/auth");

// 🔐 Routes protégées (superadmin uniquement pour modifications)
router.get("/", verifyToken, permissionController.getAllPermissions);
router.get("/:id", verifyToken, permissionController.getPermissionById);
router.post("/", verifyToken, isSuperAdmin, permissionController.createPermission);
router.post("/assign", verifyToken, isSuperAdmin, permissionController.assignPermissionsToRole);
router.get("/role/:role_id", verifyToken, permissionController.getPermissionsByRole);
router.put("/:id", verifyToken, isSuperAdmin, permissionController.updatePermission);
// place more specific route before generic :id route to avoid misinterpretation
router.delete("/unassign", verifyToken, isSuperAdmin, permissionController.unassignPermissionsFromRole);
router.delete("/:id", verifyToken, isSuperAdmin, permissionController.deletePermission);

module.exports = router;
