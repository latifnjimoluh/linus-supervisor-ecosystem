const express = require('express');
const router = express.Router();
const { deploy } = require('../../controllers/terraform/terraformController');
const { verifyToken, checkPermission } = require('../../middlewares/auth');

router.post('/deploy', verifyToken, checkPermission('deployment.run'), deploy);

module.exports = router;
