const express = require("express");
const router = express.Router();

const userAuthRoutes = require("./user/userAuthRoutes");
const deployRoutes = require("./vm/deployVm");
const deleteVMRoutes = require("./vm/deleteVm");
const checkVMStatusRoutes = require("./vm/statusVm");
const startVMRoutes = require("./vm/startVm");
const stopVMRoutes = require("./vm/stopVm");
const configureServiceRoutes = require("./services/serviceConfigRoutes");
const monitoringScriptRoutes = require("./scripts/monitoringScriptRoutes");
const initScriptRoutes = require("./scripts/initScriptRoutes");
const monitoringServiceRoutes = require("./services/monitoringServiceRoutes");
const templateConfigRoutes = require("./template/configTemplateRoutes");
const convertTemplateRoutes = require("./templateRoutes");
const supervisionRoutes = require("./supervision/supervisionRoutes");
const settingsRoutes = require("./user/userSettingsRoutes");
const userRoleRoutes = require("./user/userRoleRoutes");
const userRoutes = require("./user/userRoutes");
const userPermissionRoutes = require("./user/userPermissionRoutes");

// Permissions

// Routes principales
router.use("/auth", userAuthRoutes);
router.use("/users", userRoutes);
router.use("/permissions", userPermissionRoutes);
router.use("/user-roles", userRoleRoutes);
router.use("/settings", settingsRoutes);

// VM management
router.use("/vm", deleteVMRoutes);
router.use("/vm", deployRoutes);
router.use("/vm", checkVMStatusRoutes);
router.use("/vm", startVMRoutes);
router.use("/vm", stopVMRoutes);

// Services & Scripts
router.use("/services", configureServiceRoutes);
router.use("/monitoring", monitoringScriptRoutes);
router.use("/monitoring", monitoringServiceRoutes);
router.use("/init-scripts", initScriptRoutes);

// Supervision & Template
router.use("/supervision", supervisionRoutes);
router.use("/templates", templateConfigRoutes);
router.use("/convert-template", convertTemplateRoutes);

module.exports = router;
