const express = require('express');
const router = express.Router();
const settingsController = require('../../controllers/settings/userSettingController');
const { verifyToken, checkPermission } = require('../../middlewares/auth');
const { logRequest } = require('../../middlewares/log');

console.log('🚦 userSettingRoutes initialisé');

router.use((req, res, next) => {
  console.log(`➡️ [Route Settings] ${req.method} ${req.originalUrl}`);
  next();
});

router.use(verifyToken, logRequest);

router.get('/alerts', checkPermission('settings.get'), settingsController.getAlertThresholds);
router.post('/alerts', checkPermission('settings.create'), settingsController.createAlertThresholds);
router.put('/alerts', checkPermission('settings.update'), settingsController.updateAlertThresholds);
router.get('/me', checkPermission('settings.get'), settingsController.getUserSettings);
router.post('/me', checkPermission('settings.create'), settingsController.createUserSettings);
router.put('/me', checkPermission('settings.update'), settingsController.updateUserSettings);
router.put('/storage', checkPermission('settings.update'), settingsController.updateStorageSettings);
router.get('/account', checkPermission('settings.get'), settingsController.getAccountInfo);
router.get('/', checkPermission('settings.list'), settingsController.listAllSettings);

module.exports = router;
