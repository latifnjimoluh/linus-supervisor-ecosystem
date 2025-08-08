const express = require('express');
const router = express.Router();
const { verifyToken, checkPermission } = require('../../middlewares/auth');
const { logRequest } = require('../../middlewares/log');
const { list, getById, create, update, remove } = require('../../controllers/servers/serverController');

router.get('/', verifyToken, checkPermission('servers.view'), logRequest, list);
router.get('/:id', verifyToken, checkPermission('servers.view'), logRequest, getById);
router.post('/', verifyToken, checkPermission('servers.add'), logRequest, create);
router.put('/:id', verifyToken, checkPermission('servers.edit'), logRequest, update);
router.delete('/:id', verifyToken, checkPermission('servers.delete'), logRequest, remove);

module.exports = router;
