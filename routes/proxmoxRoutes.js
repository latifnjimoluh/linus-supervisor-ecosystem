const express = require('express');
const router = express.Router();
const { verifyToken } = require('../middlewares/auth');
const { listVMs, startVM, stopVM, convertToTemplate, getConversionHistory, checkVMStatus } = require('../controllers/proxmoxController');

router.get('/', verifyToken, listVMs);
router.post('/:vmId/start', verifyToken, startVM);
router.post('/:vmId/stop', verifyToken, stopVM);
router.post('/convert', verifyToken, convertToTemplate);
router.get('/conversions', verifyToken, getConversionHistory);
router.post('/check-status', verifyToken, checkVMStatus);

module.exports = router;
