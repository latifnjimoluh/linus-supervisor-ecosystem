const express = require('express');
const router = express.Router();
const settingsController = require('../controllers/userSettingController');
const { verifyToken, isSuperAdmin } = require('../middlewares/auth');
const { logRequest } = require('../middlewares/log');

console.log('🚦 userSettingRoutes initialisé');

router.use((req, res, next) => {
  console.log(`➡️ [Route Settings] ${req.method} ${req.originalUrl}`);
  next();
});

router.use(verifyToken, logRequest);

router.get('/me', settingsController.getUserSettings);
router.post('/me', settingsController.createUserSettings);
router.put('/me', settingsController.updateUserSettings);
router.get('/', isSuperAdmin, settingsController.listAllSettings);

module.exports = router;
