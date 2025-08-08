const express = require('express');
const router = express.Router();
const { preview } = require('../../controllers/scripts/scriptController');

router.get('/preview/:serverId/:service', preview);

module.exports = router;
