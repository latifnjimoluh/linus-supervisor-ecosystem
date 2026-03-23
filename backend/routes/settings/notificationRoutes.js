const express = require('express');
const router = express.Router();
const controller = require('../../controllers/settings/notificationController');
const { verifyToken, checkPermission } = require('../../middlewares/auth');
const { logRequest } = require('../../middlewares/log');

router.use(verifyToken, logRequest);

router.get('/', checkPermission('settings.notifications.read'), controller.getSettings);
router.put('/', checkPermission('settings.notifications.update'), controller.updateSettings);
router.post('/test', checkPermission('settings.notifications.test'), controller.testNotification);

module.exports = router;
