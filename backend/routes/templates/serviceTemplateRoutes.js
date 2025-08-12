const express = require('express');
const router = express.Router();
const serviceTemplateController = require('../../controllers/templates/serviceTemplateController');
const { verifyToken, checkPermission } = require('../../middlewares/auth');
const { logRequest } = require('../../middlewares/log');

console.log('🚦 serviceTemplateRoutes initialisé');

router.use((req, res, next) => {
  console.log(`➡️ [Route Templates] ${req.method} ${req.originalUrl}`);
  next();
});

router.use(verifyToken, logRequest);

router.get('/', checkPermission('template.list'), serviceTemplateController.getAllTemplates);
router.post('/', checkPermission('template.create'), serviceTemplateController.createTemplate);
router.post('/generate', checkPermission('template.generate'), serviceTemplateController.generateScript);
router.post('/explain', checkPermission('template.explain'), serviceTemplateController.explainScript);
router.post('/analyze', checkPermission('template.analyze'), serviceTemplateController.analyzeScript);
router.post('/variables/explain', checkPermission('template.explainVariables'), serviceTemplateController.explainVariables);
router.post('/logs/summarize', checkPermission('template.summarizeLogs'), serviceTemplateController.summarizeLogs);
router.post('/bundle', checkPermission('template.suggestBundle'), serviceTemplateController.suggestBundle);
router.post('/simulate', checkPermission('template.simulateExecution'), serviceTemplateController.simulateScript);
router.get('/:id', checkPermission('template.read'), serviceTemplateController.getTemplateById);
router.put('/:id', checkPermission('template.update'), serviceTemplateController.updateTemplate);
router.delete('/:id', checkPermission('template.delete'), serviceTemplateController.deleteTemplate);
router.post('/:id/restore', checkPermission('template.restore'), serviceTemplateController.restoreTemplate);

module.exports = router;
