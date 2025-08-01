const express = require("express");
const router = express.Router();

const userAuthRoutes = require("./user/userAuthRoutes");
const deployRoutes = require("./vm/deployVm");
const configureService = require("./services/serviceConfigRoutes");
const monitoringRoutes = require("./scripts/monitoringScriptRoutes");
const templateRoutes = require("./template/configTemplateRoutes");
const monitoringServiceRoutes = require("./services/monitoringServiceRoutes");
const initScriptRoutes = require("./scripts/initScriptRoutes");
const supervisionRoutes = require("./supervision/supervisionRoutes");
const deleteVMDirect = require("./vm/deleteVm");
const settingsRoutes = require("./user/userSettingsRoutes");
const convertTemplateRoutes = require("./templateRoutes");
const statusVmRoutes = require("./vm/statusVm");
const userroles = require("./user/userRoleRoutes");
const userRoutes = require("./user/userRoutes");




router.use("/auth", userAuthRoutes);
router.use("/", deployRoutes);
router.use("/services", configureService);
router.use("/monitoring", monitoringRoutes);
router.use("/templates", templateRoutes);
router.use("/", monitoringServiceRoutes);
router.use("/init-scripts", initScriptRoutes);
router.use("/supervision", supervisionRoutes);
router.use("/vm", deleteVMDirect);
router.use("/settings", settingsRoutes);
router.use("/convert-template", convertTemplateRoutes);
router.use("/status-vm", statusVmRoutes);
router.use("/user-roles", userroles);
router.use("/users", userRoutes);




module.exports = router;
