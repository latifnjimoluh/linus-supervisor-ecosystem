const express = require('express');
const router = express.Router();

router.use('/auth', require('./auth/authRoutes'));
router.use('/permissions', require('./permissions/permissionRoutes'));
router.use('/roles', require('./roles/roleRoutes'));
router.use('/users', require('./users/userRoutes'));
router.use('/logs', require('./logs/logRoutes'));
router.use('/settings', require('./settings/userSettingRoutes'));
router.use('/vms', require('./proxmox/proxmoxRoutes'));
router.use('/templates', require('./templates/serviceTemplateRoutes'));
router.use('/terraform', require('./terraform/terraformRoutes'));

module.exports = router;
