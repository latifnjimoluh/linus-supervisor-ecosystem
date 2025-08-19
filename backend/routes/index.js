// routes/index.js
const express = require("express");
const router = express.Router();

router.use('/auth', require('./auth/authRoutes'));
router.use('/permissions', require('./permissions/permissionRoutes'));
router.use('/roles', require('./roles/roleRoutes'));
router.use('/users', require('./users/userRoutes'));
router.use('/logs', require('./logs/logRoutes'));
router.use('/settings/notifications', require('./settings/notificationRoutes'));
router.use('/settings', require('./settings/userSettingRoutes'));
router.use('/vms', require('./proxmox/proxmoxRoutes'));
router.use('/templates', require('./templates/serviceTemplateRoutes'));
router.use('/terraform', require('./terraform/terraformRoutes'));
router.use('/monitoring', require('./monitoring/monitoringRoutes'));
router.use('/dashboard', require('./dashboard/dashboardRoutes'));
router.use('/alerts', require('./alerts/alertRoutes'));
router.use('/ai-cache', require('./ai/aiCacheRoutes'));
router.use('/scripts', require('./scripts/scriptRoutes'));
router.use('/terminal', require('./terminal/terminalRoutes'));
router.use('/terminal', require('./terminal/sshRoutes'));
router.use('/deployments', require('./deployments/deploymentRoutes'));
router.use('/chat', require('./chat/chatRoutes'));
router.use('/alerts', require('./alerts/ingest'));  

module.exports = router;
