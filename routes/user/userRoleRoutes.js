const express = require("express");
const router = express.Router();
const roleController = require("../../controllers/user/userRoleController");
const { verifyToken, checkPermission } = require("../../middlewares/auth");
const logUserAction = require("../../middlewares/logUserAction");


router.get(
  "/",
  verifyToken,
  checkPermission("roles.read"),
  logUserAction("Consultation des rôles"),
  roleController.getAllRoles
);
router.get(
  "/:id",
  verifyToken,
  checkPermission("roles.read"),
  logUserAction("Consultation d'un rôle", req => `ID: ${req.params.id}`),
  roleController.getRoleById
);
router.post(
  "/",
  verifyToken,
  checkPermission("roles.create"),
  logUserAction("Création d'un rôle", req => `Body: ${JSON.stringify(req.body)}`),
  roleController.createRole
);
router.put(
  "/:id",
  verifyToken,
  checkPermission("roles.update"),
  logUserAction("Mise à jour d'un rôle", req => `ID: ${req.params.id}`),
  roleController.updateRole
);
router.delete(
  "/:id",
  verifyToken,
  checkPermission("roles.delete"),
  logUserAction("Suppression d'un rôle", req => `ID: ${req.params.id}`),
  roleController.deleteRole
);

module.exports = router;
