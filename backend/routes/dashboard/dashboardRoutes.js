const express = require('express');
const router = express.Router();
const { verifyToken, checkPermission } = require('../../middlewares/auth');
const { logRequest } = require('../../middlewares/log');
const {
  getSummary,
  listServers,
  getDashboardData,
  getDeploymentStats,
  getDeploymentInsights,
  getInfrastructureMap,
  createServer,
  deleteServer,
} = require('../../controllers/dashboard/dashboardController');

router.get('/', verifyToken, checkPermission('dashboard.view'), logRequest, getDashboardData);
router.get('/summary', verifyToken, checkPermission('dashboard.view'), logRequest, getSummary);
router.get('/servers', verifyToken, checkPermission('dashboard.view'), logRequest, listServers);
router.post('/servers', verifyToken, checkPermission('dashboard.view'), logRequest, createServer);
router.delete('/servers/:id', verifyToken, checkPermission('dashboard.view'), logRequest, deleteServer);
router.get('/map', verifyToken, checkPermission('dashboard.view'), logRequest, getInfrastructureMap);
router.get('/stats', verifyToken, checkPermission('dashboard.view'), logRequest, getDeploymentStats);
router.get('/insights', verifyToken, checkPermission('dashboard.view'), logRequest, getDeploymentInsights);

module.exports = router;
