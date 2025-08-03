// 📁 routes/permissions/permissionRoutes.js
const express = require("express");
const router = express.Router();
const permissionController = require("../../controllers/user/userPermissionController");
const { verifyToken, isSuperAdmin } = require("../../middlewares/auth");
const logUserAction = require("../../middlewares/logUserAction");

// 🔐 Routes protégées (superadmin uniquement pour modifications)
router.get(
  "/",
  verifyToken,
  logUserAction("Consultation des permissions"),
  permissionController.getAllPermissions
);
router.get(
  "/:id",
  verifyToken,
  logUserAction("Consultation d'une permission", req => `ID: ${req.params.id}`),
  permissionController.getPermissionById
);
router.post(
  "/",
  verifyToken,
  isSuperAdmin,
  logUserAction("Création d'une permission", req => `Body: ${JSON.stringify(req.body)}`),
  permissionController.createPermission
);
router.post(
  "/assign",
  verifyToken,
  isSuperAdmin,
  logUserAction("Attribution de permissions à un rôle", req => `Body: ${JSON.stringify(req.body)}`),
  permissionController.assignPermissionsToRole
);
router.get(
  "/role/:role_id",
  verifyToken,
  logUserAction("Consultation des permissions d'un rôle", req => `role_id: ${req.params.role_id}`),
  permissionController.getPermissionsByRole
);
router.put(
  "/:id",
  verifyToken,
  isSuperAdmin,
  logUserAction("Mise à jour d'une permission", req => `ID: ${req.params.id}`),
  permissionController.updatePermission
);
// place more specific route before generic :id route to avoid misinterpretation
router.delete(
  "/unassign",
  verifyToken,
  isSuperAdmin,
  logUserAction("Retrait de permissions d'un rôle", req => `Body: ${JSON.stringify(req.body)}`),
  permissionController.unassignPermissionsFromRole
);
router.delete(
  "/:id",
  verifyToken,
  isSuperAdmin,
  logUserAction("Suppression d'une permission", req => `ID: ${req.params.id}`),
  permissionController.deletePermission
);

module.exports = router;
