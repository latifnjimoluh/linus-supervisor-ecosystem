const express = require("express");
const router = express.Router();
const roleController = require("../../controllers/user/userRoleController");

// GET tous les rôles
router.get("/", roleController.getAllRoles);

// POST création d'un rôle
router.post("/", roleController.createRole);

// PUT mise à jour d'un rôle
router.put("/:id", roleController.updateRole);

// DELETE suppression d'un rôle
router.delete("/:id", roleController.deleteRole);

module.exports = router;