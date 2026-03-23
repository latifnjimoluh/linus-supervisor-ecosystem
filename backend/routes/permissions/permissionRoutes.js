const express = require('express');
const router = express.Router();
const permissionController = require('../../controllers/permissions/permissionController');
const { verifyToken, checkPermission } = require('../../middlewares/auth');
const { logRequest } = require('../../middlewares/log');

console.log('🚦 permissionRoutes initialisé');

router.use((req, res, next) => {
  console.log(`➡️ [Route Permissions] ${req.method} ${req.originalUrl}`);
  next();
});

router.use(verifyToken, logRequest);

router.get('/', checkPermission('permission.list'), permissionController.getAllPermissions);
router.post('/', checkPermission('permission.create'), permissionController.createPermission);
router.post('/assign', checkPermission('permission.assign'), permissionController.assignPermissionsToRole);
router.post('/unassign', checkPermission('permission.unassign'), permissionController.unassignPermissionsFromRole);
router.get('/role/:role_id', checkPermission('permission.byRole'), permissionController.getPermissionsByRole);
router.get('/:id', checkPermission('permission.read'), permissionController.getPermissionById);
router.put('/:id', checkPermission('permission.update'), permissionController.updatePermission);
router.delete('/:id', checkPermission('permission.delete'), permissionController.deletePermission);

module.exports = router;
