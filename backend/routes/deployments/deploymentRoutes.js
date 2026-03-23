const express = require('express');
const router = express.Router();
const { verifyToken, checkPermission } = require('../../middlewares/auth');
const {
  getById,
  getLast,
  summarizeLogs,
  history,
  analyzeConfig,
  checkCapacity,
} = require('../../controllers/deployments/deploymentController');
const { stream } = require("../../controllers/deployments/stream");

router.get('/history', verifyToken, checkPermission('deployment.run'), history);
router.get('/check-capacity', verifyToken, checkPermission('deployment.run'), checkCapacity);
router.post('/analyze', verifyToken, checkPermission('deployment.run'), analyzeConfig);
router.get('/last', verifyToken, checkPermission('deployment.run'), getLast);
router.get('/:id/stream', verifyToken, checkPermission('deployment.run'), stream);
router.get('/:id', verifyToken, checkPermission('deployment.run'), getById);
router.get('/:id/summary', verifyToken, checkPermission('deployment.run'), summarizeLogs);

module.exports = router;
