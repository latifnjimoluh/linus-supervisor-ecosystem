const express = require('express');
const router = express.Router();
const permissionController = require('../controllers/permissionController');
const { verifyToken } = require('../middlewares/auth');
const { logRequest } = require('../middlewares/log');

console.log('🚦 permissionRoutes initialisé');

router.use((req, res, next) => {
  console.log(`➡️ [Route Permissions] ${req.method} ${req.originalUrl}`);
  next();
});

router.use(verifyToken, logRequest);

router.get('/', permissionController.getAllPermissions);
router.post('/', permissionController.createPermission);
router.post('/assign', permissionController.assignPermissionsToRole);
router.post('/unassign', permissionController.unassignPermissionsFromRole);
router.get('/role/:role_id', permissionController.getPermissionsByRole);
router.get('/:id', permissionController.getPermissionById);
router.put('/:id', permissionController.updatePermission);
router.delete('/:id', permissionController.deletePermission);

module.exports = router;
