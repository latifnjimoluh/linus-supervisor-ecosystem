const express = require('express');
const router = express.Router();
const { verifyToken, checkPermission } = require('../../middlewares/auth');
const monitoringController = require('../../controllers/monitoring/monitoringController');

router.get('/', verifyToken, checkPermission('monitoring.list'), monitoringController.getMonitoringRecords);
router.get('/overview', verifyToken, checkPermission('monitoring.list'), monitoringController.getOverview);
router.get('/proxmox/summary', verifyToken, checkPermission('monitoring.list'), monitoringController.getVmSummary);
router.get('/vm/:vmid', verifyToken, checkPermission('monitoring.read'), monitoringController.getVmDetails);
router.get('/:id', verifyToken, checkPermission('monitoring.read'), monitoringController.getMonitoringRecordById);
router.post('/collect', verifyToken, checkPermission('monitoring.collect'), monitoringController.collectMonitoringData);
router.post('/sync-ip', verifyToken, checkPermission('monitoring.sync'), monitoringController.syncDeploymentIP);

module.exports = router;
