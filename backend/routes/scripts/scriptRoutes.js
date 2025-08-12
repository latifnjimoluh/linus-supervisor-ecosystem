const express = require('express');
const router = express.Router();
const {
  preview,
  listGeneratedScripts,
  listServiceTypes,
  getGeneratedScript,
  analyzeScript,
  deleteScript,
  restoreScript,
} = require('../../controllers/scripts/scriptController');
const { verifyToken, checkPermission } = require('../../middlewares/auth');
const { logRequest } = require('../../middlewares/log');

// Open routes
router.get('/preview/:serverId/:service', preview);
router.get('/generated/:id', getGeneratedScript);
router.get('/:id', getGeneratedScript);

// Protected routes
router.use(verifyToken, logRequest);

router.get('/generated', checkPermission('script.list'), listGeneratedScripts);
router.get('/service-types', checkPermission('script.serviceTypes'), listServiceTypes);
router.post('/:id/analyze', checkPermission('script.analyze'), analyzeScript);
router.delete('/:id', checkPermission('script.delete'), deleteScript);
router.post('/:id/restore', checkPermission('script.restore'), restoreScript);

module.exports = router;
