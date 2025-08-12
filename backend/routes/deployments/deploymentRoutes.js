const express = require('express');
const router = express.Router();
const { verifyToken, checkPermission } = require('../../middlewares/auth');
const {
  getById,
  summarizeLogs,
  history,
  analyzeConfig,
  checkSpace,
} = require('../../controllers/deployments/deploymentController');
const { stream } = require("../../controllers/deployments/stream");

router.get('/history', verifyToken, checkPermission('deployment.run'), history);
router.get('/check-space', verifyToken, checkPermission('deployment.run'), checkSpace);
router.post('/analyze', verifyToken, checkPermission('deployment.run'), analyzeConfig);
router.get('/:id/stream', stream);
router.get('/:id', verifyToken, checkPermission('deployment.run'), getById);
router.get('/:id/summary', verifyToken, checkPermission('deployment.run'), summarizeLogs);

module.exports = router;
