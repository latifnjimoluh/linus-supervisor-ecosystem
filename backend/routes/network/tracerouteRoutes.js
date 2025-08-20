const express = require('express');
const router = express.Router();
const { verifyToken } = require('../../middlewares/auth');
const controller = require('../../controllers/network/tracerouteController');

router.post('/traceroute', verifyToken, controller.run);

module.exports = router;
