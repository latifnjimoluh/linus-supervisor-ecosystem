const express = require('express');
const router = express.Router();
const { verifyToken, checkPermission } = require('../../middlewares/auth');
const { logRequest } = require('../../middlewares/log');
const { getSummary, listServers } = require('../../controllers/dashboard/dashboardController');

router.get('/summary', verifyToken, checkPermission('dashboard.view'), logRequest, getSummary);
router.get('/servers', verifyToken, checkPermission('dashboard.view'), logRequest, listServers);

module.exports = router;
