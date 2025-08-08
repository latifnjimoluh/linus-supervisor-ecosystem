const express = require('express');
const router = express.Router();
const roleController = require('../../controllers/roles/roleController');
const { verifyToken, checkPermission } = require('../../middlewares/auth');
const { logRequest } = require('../../middlewares/log');

console.log('🚦 roleRoutes initialisé');

router.use((req, res, next) => {
  console.log(`➡️ [Route Roles] ${req.method} ${req.originalUrl}`);
  next();
});

router.use(verifyToken, logRequest);

router.get('/', checkPermission('role.list'), roleController.getAllRoles);
router.get('/:id', checkPermission('role.read'), roleController.getRoleById);
router.post('/', checkPermission('role.create'), roleController.createRole);
router.put('/:id', checkPermission('role.update'), roleController.updateRole);
router.delete('/:id', checkPermission('role.delete'), roleController.deleteRole);

module.exports = router;
