const express = require('express');
const router = express.Router();
const snmpController = require('../../controllers/network/snmpController');

router.get('/snmp/interface-status', snmpController.checkInterface);

module.exports = router;
