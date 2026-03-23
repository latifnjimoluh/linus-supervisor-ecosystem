const express = require('express');
const router = express.Router();
const alertController = require('../../controllers/alerts/alertController');
const { verifyToken, checkPermission } = require('../../middlewares/auth');
const { logRequest } = require('../../middlewares/log');

router.use(verifyToken, logRequest);

router.get('/', checkPermission('alert.list'), alertController.listAlerts);
router.get('/:id', checkPermission('alert.list'), alertController.getAlert);
router.post('/:id/ack', checkPermission('alert.update'), alertController.ackAlert);
router.patch('/:id', checkPermission('alert.update'), alertController.updateAlert);

module.exports = router;
