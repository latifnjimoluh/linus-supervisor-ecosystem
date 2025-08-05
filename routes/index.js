const express = require("express");
const router = express.Router();

// 🔐 Authentification & Utilisateurs
const userAuthRoutes = require("./user/userAuthRoutes");
const userRoutes = require("./user/userRoutes");
const userRoleRoutes = require("./user/userRoleRoutes");
const userPermissionRoutes = require("./user/userPermissionRoutes");
const userActivityLogRoutes = require("./user/userActivityLogRoutes");
const settingsRoutes = require("./user/userSettingsRoutes");

// 🖥️ Gestion des VM
const deployRoutes = require("./vm/deployVm");
const deleteVMRoutes = require("./vm/deleteVm");
const checkVMStatusRoutes = require("./vm/statusVm");
const startVMRoutes = require("./vm/startVm");
const stopVMRoutes = require("./vm/stopVm");
const listVmRoutes = require("./vm/listVmRoutes");

// ⚙️ Gestion des services et scripts

// 🧠 Supervision & Templates
const supervisionRoutes = require("./supervision/supervisionRoutes");
const convertTemplateRoutes = require("./template/templateRoutes");

// 🔐 Authentification & Utilisateurs
router.use("/auth", userAuthRoutes);
router.use("/users", userRoutes);
router.use("/user-roles", userRoleRoutes);
router.use("/permissions", userPermissionRoutes);
router.use("/user-activity-logs", userActivityLogRoutes);
router.use("/settings", settingsRoutes);

// 🖥️ VM management (même préfixe, ordre important)
router.use("/vm", deployRoutes);
router.use("/vm", deleteVMRoutes);
router.use("/vm", checkVMStatusRoutes);
router.use("/vm", startVMRoutes);
router.use("/vm", stopVMRoutes);
router.use("/vm", listVmRoutes);

// ⚙️ Services & Scripts

// 🧠 Supervision & Templates
router.use("/supervision", supervisionRoutes);
router.use("/convert-template", convertTemplateRoutes);

module.exports = router;
