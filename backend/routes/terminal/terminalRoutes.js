const express = require('express');
const router = express.Router();
const { verifyToken, checkPermission } = require('../../middlewares/auth');
const { logRequest } = require('../../middlewares/log');
const { listTerminalVMs } = require('../../controllers/terminal/terminalController');

router.get('/vms', verifyToken, checkPermission('vm.list'), logRequest, listTerminalVMs);

module.exports = router;
