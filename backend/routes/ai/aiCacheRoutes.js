const express = require('express');
const router = express.Router();
const aiCacheController = require('../../controllers/ai/aiCacheController');
const { verifyToken, checkPermission } = require('../../middlewares/auth');
const { logRequest } = require('../../middlewares/log');

router.use((req, res, next) => {
  console.log(`➡️ [Route AiCache] ${req.method} ${req.originalUrl}`);
  next();
});

router.use(verifyToken, logRequest);

router.get('/', checkPermission('aiCache.list'), aiCacheController.list);
router.post('/', checkPermission('aiCache.create'), aiCacheController.create);
router.get('/:id', checkPermission('aiCache.read'), aiCacheController.getById);
router.put('/:id', checkPermission('aiCache.update'), aiCacheController.update);
router.delete('/:id', checkPermission('aiCache.delete'), aiCacheController.remove);

module.exports = router;
