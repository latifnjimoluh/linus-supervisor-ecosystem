const express = require('express');
const router = express.Router();
const { verifyToken, checkPermission } = require('../../middlewares/auth');
const { logRequest } = require('../../middlewares/log');
const { listVMs, startVM, stopVM, convertToTemplate, getConversionHistory, checkVMStatus } = require('../../controllers/proxmox/proxmoxController');

router.get('/', verifyToken, checkPermission('vm.list'), logRequest, listVMs);
router.post('/:vmId/start', verifyToken, checkPermission('vm.start'), logRequest, startVM);
router.post('/:vmId/stop', verifyToken, checkPermission('vm.stop'), logRequest, stopVM);
router.post('/convert', verifyToken, checkPermission('vm.convert'), logRequest, convertToTemplate);
router.get('/conversions', verifyToken, checkPermission('vm.conversion.list'), logRequest, getConversionHistory);
router.post('/check-status', verifyToken, checkPermission('vm.status.check'), logRequest, checkVMStatus);

module.exports = router;
