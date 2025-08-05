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
router.get('/:id', checkPermission('template.read'), serviceTemplateController.getTemplateById);
router.put('/:id', checkPermission('template.update'), serviceTemplateController.updateTemplate);
router.delete('/:id', checkPermission('template.delete'), serviceTemplateController.deleteTemplate);

module.exports = router;
