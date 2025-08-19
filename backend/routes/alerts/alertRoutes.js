const express = require('express');
const router = express.Router();
const alertController = require('../../controllers/alerts/alertController');
const { verifyToken, checkPermission } = require('../../middlewares/auth');
const { logRequest } = require('../../middlewares/log');

router.use(verifyToken, logRequest);

router.get('/', checkPermission('alert.list'), alertController.listAlerts);
router.get('/notifications/status', checkPermission('alert.list'), alertController.notificationStatuses);
router.get('/:id', checkPermission('alert.list'), alertController.getAlert);
router.post('/:id/mark', checkPermission('alert.update'), alertController.markAlert);
router.post('/:id/resend', checkPermission('alert.update'), alertController.resendNotification);
router.patch('/:id', checkPermission('alert.update'), alertController.updateAlert);

module.exports = router;
