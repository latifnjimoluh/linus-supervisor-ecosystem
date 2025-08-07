const express = require('express');
const router = express.Router();
const userController = require('../../controllers/users/userController');
const { verifyToken, checkPermission } = require('../../middlewares/auth');
const { logRequest } = require('../../middlewares/log');
const logger = require('../../utils/logger');

logger.info('userRoutes initialisé');

router.use((req, res, next) => {
  logger.debug('[Route Users]', { method: req.method, url: req.originalUrl });
  next();
});

router.use(verifyToken, logRequest);

router.get('/', checkPermission('user.list'), userController.getAllUsers);
router.get('/search', checkPermission('user.search'), userController.searchUsers);
router.get('/:id', checkPermission('user.read'), userController.getUserById);
router.post('/', checkPermission('user.create'), userController.createUser);
router.put('/:id', checkPermission('user.update'), userController.updateUser);
router.patch('/:id', checkPermission('user.update'), userController.patchUser);
router.delete('/:id', checkPermission('user.delete'), userController.softDeleteUser);

module.exports = router;
