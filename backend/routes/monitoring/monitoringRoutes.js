const express = require('express');
const router = express.Router();
const { verifyToken, checkPermission } = require('../../middlewares/auth');
const monitoringController = require('../../controllers/monitoring/monitoringController');

// Overview of VMs
router.get('/', verifyToken, checkPermission('monitoring.list'), monitoringController.getOverview);

// Raw monitoring records
router.get('/records', verifyToken, checkPermission('monitoring.list'), monitoringController.getMonitoringRecords);
router.get('/records/:id', verifyToken, checkPermission('monitoring.read'), monitoringController.getMonitoringRecordById);

router.get('/proxmox/summary', verifyToken, checkPermission('monitoring.list'), monitoringController.getVmSummary);

// History and details for a specific VM
router.get('/:vmid/history', verifyToken, checkPermission('monitoring.list'), monitoringController.getVmHistory);
router.get('/:vmid/system', verifyToken, checkPermission('monitoring.read'), monitoringController.getVmSystemInfo);
router.get('/:vmid', verifyToken, checkPermission('monitoring.read'), monitoringController.getVmDetails);

router.post('/collect', verifyToken, checkPermission('monitoring.collect'), monitoringController.collectMonitoringData);
router.post('/sync-ip', verifyToken, checkPermission('monitoring.sync'), monitoringController.syncDeploymentIP);

module.exports = router;
