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
  updateScript,
} = require('../../controllers/scripts/scriptController');

const { verifyToken, checkPermission } = require('../../middlewares/auth');
const { logRequest } = require('../../middlewares/log');


// --- Routes protégées par token
router.get(
  '/service-types',
  verifyToken, // ⬅ On vérifie le token avant de contrôler la permission
  checkPermission('script.servicetypes'),
  listServiceTypes
);


router.get(
  '/generated',
  verifyToken, // ⬅ On vérifie le token avant de contrôler la permission
  checkPermission('script.list'),
  listGeneratedScripts
);

router.get('/generated/:id', getGeneratedScript);

// --- Routes ouvertes (pas besoin de token)
router.get('/preview/:serverId/:service', preview);

router.get('/:id', getGeneratedScript);

router.use(verifyToken, logRequest);


router.post(
  '/:id/analyze',
  checkPermission('script.analyze'),
  analyzeScript
);

router.delete(
  '/:id',
  checkPermission('script.delete'),
  deleteScript
);

router.post(
  '/:id/restore',
  checkPermission('script.restore'),
  restoreScript
);

router.put(
  '/:id',
  checkPermission('script.update'),
  updateScript
);


module.exports = router;
