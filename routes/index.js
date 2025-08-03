const express = require("express");
const router = express.Router();

const userAuthRoutes = require("./user/userAuthRoutes");
const deployRoutes = require("./vm/deployVm");
const deleteVMRoutes = require("./vm/deleteVm");
const checkVMStatusRoutes = require("./vm/statusVm");
const startVMRoutes = require("./vm/startVm");
const stopVMRoutes = require("./vm/stopVm");
const listVmRoutes = require("./vm/listVmRoutes");
const serviceTemplateRoutes = require("./services/serviceTemplateRoutes");
const monitoringScriptRoutes = require("./scripts/monitoringScriptRoutes");
const initializationScriptRoutes = require("./scripts/initializationScriptRoutes");
const monitoredServiceRoutes = require("./services/monitoredServiceRoutes");
const templateConfigRoutes = require("./template/configTemplateRoutes");
const convertTemplateRoutes = require("./template/templateRoutes");
const supervisionRoutes = require("./supervision/supervisionRoutes");
const settingsRoutes = require("./user/userSettingsRoutes");
const userRoleRoutes = require("./user/userRoleRoutes");
const userRoutes = require("./user/userRoutes");
const userPermissionRoutes = require("./user/userPermissionRoutes");
const userActivityLogRoutes = require("./user/userActivityLogRoutes");

// Permissions

// Routes principales
router.use("/auth", userAuthRoutes);
router.use("/users", userRoutes);
router.use("/user-activity-logs", userActivityLogRoutes);
router.use("/permissions", userPermissionRoutes);
router.use("/user-roles", userRoleRoutes);
router.use("/settings", settingsRoutes);

// VM management
router.use("/vm", deleteVMRoutes);
router.use("/vm", deployRoutes);
router.use("/vm", checkVMStatusRoutes);
router.use("/vm", startVMRoutes);
router.use("/vm", stopVMRoutes);
router.use("/vm", listVmRoutes);

// Services & Scripts
router.use("/service-templates", serviceTemplateRoutes);
router.use("/monitoring", monitoringScriptRoutes);
router.use("/monitoring", monitoredServiceRoutes);
router.use("/initialization-scripts", initializationScriptRoutes);

// Supervision & Template
router.use("/supervision", supervisionRoutes);
router.use("/templates", templateConfigRoutes);
router.use("/convert-template", convertTemplateRoutes);

module.exports = router;
