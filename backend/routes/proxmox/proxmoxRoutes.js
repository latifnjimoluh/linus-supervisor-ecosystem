const express = require('express');
const router = express.Router();
const { verifyToken, checkPermission } = require('../../middlewares/auth');
const { logRequest } = require('../../middlewares/log');
const {
  listVMs,
  listStorages,
  listNodes,
  getSystemInfo,
  startVM,
  stopVM,
  convertToTemplate,
  getConversionHistory,
  checkVMStatus,
  deleteVMDirect,
} = require('../../controllers/proxmox/proxmoxController');

router.get('/', verifyToken, checkPermission('vm.list'), logRequest, listVMs);
router.get('/nodes', verifyToken, checkPermission('settings.get'), logRequest, listNodes);
router.get('/system', verifyToken, checkPermission('settings.get'), logRequest, getSystemInfo);
router.get('/storages', verifyToken, checkPermission('settings.get'), logRequest, listStorages);
router.post('/:vmId/start', verifyToken, checkPermission('vm.start'), logRequest, startVM);
router.post('/:vmId/stop', verifyToken, checkPermission('vm.stop'), logRequest, stopVM);
router.post('/delete', verifyToken, checkPermission('vm.delete'), logRequest, deleteVMDirect);
router.post('/convert', verifyToken, checkPermission('vm.convert'), logRequest, convertToTemplate);
router.get('/conversions', verifyToken, checkPermission('vm.conversion.list'), logRequest, getConversionHistory);
router.post('/check-status', verifyToken, checkPermission('vm.status.check'), logRequest, checkVMStatus);

module.exports = router;
