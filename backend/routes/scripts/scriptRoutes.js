const express = require('express');
const router = express.Router();
const { preview, listGeneratedScripts, listServiceTypes } = require('../../controllers/scripts/scriptController');

router.get('/preview/:serverId/:service', preview);
router.get('/generated', listGeneratedScripts);
router.get('/service-types', listServiceTypes);

module.exports = router;
