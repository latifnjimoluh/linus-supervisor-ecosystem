const express = require('express');
const router = express.Router();
const { verifyToken, checkPermission } = require('../../middlewares/auth');
const { logRequest } = require('../../middlewares/log');
const {
  getSummary,
  listServers,
  getDashboardData,
  getInfrastructureMap,
} = require('../../controllers/dashboard/dashboardController');

router.get('/', verifyToken, checkPermission('dashboard.view'), logRequest, getDashboardData);
router.get('/summary', verifyToken, checkPermission('dashboard.view'), logRequest, getSummary);
router.get('/servers', verifyToken, checkPermission('dashboard.view'), logRequest, listServers);
router.get('/map', verifyToken, checkPermission('dashboard.view'), logRequest, getInfrastructureMap);

module.exports = router;
