// routes/logs/logRoutes.js
const express = require('express');
const router = express.Router();
const logController = require('../../controllers/logs/logController');
const { verifyToken, checkPermission } = require('../../middlewares/auth');
const { logRequest } = require('../../middlewares/log');

console.log('🚦 logRoutes initialisé');

router.use((req, res, next) => {
  console.log(`➡️ [Route Logs] ${req.method} ${req.originalUrl}`);
  next();
});

router.use(verifyToken, logRequest);

router.get('/', checkPermission('log.list'), logController.getAllLogs);
router.get('/deployments', checkPermission('log.list'), logController.getDeploymentLogs);
router.get('/export', checkPermission('log.list'), logController.exportLogs);
router.head('/export', checkPermission('log.list'), logController.exportLogs);

// 🔹 NEW: téléchargement d’un log par ID
router.get('/:id/download', checkPermission('log.list'), logController.downloadLogById);
// 🔹 NEW: lecture et téléchargement d’un log de déploiement par ID (table deployments)
router.get(
  '/deployments/:id/view',
  checkPermission('log.list'),
  logController.viewDeploymentLogById
)

router.get(
  '/deployments/:id/download',
  checkPermission('log.list'),
  logController.downloadDeploymentLogById
)


module.exports = router;
