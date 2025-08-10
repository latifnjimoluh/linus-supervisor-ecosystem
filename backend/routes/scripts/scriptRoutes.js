const express = require('express');
const router = express.Router();
const { preview, listGeneratedScripts, listServiceTypes, getGeneratedScript } = require('../../controllers/scripts/scriptController');

router.get('/preview/:serverId/:service', preview);
router.get('/generated', listGeneratedScripts);
router.get('/service-types', listServiceTypes);
router.get('/:id', getGeneratedScript);

module.exports = router;
