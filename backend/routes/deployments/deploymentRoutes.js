const express = require('express');
const router = express.Router();
const { verifyToken, checkPermission } = require('../../middlewares/auth');
const { getById } = require('../../controllers/deployments/deploymentController');

router.get('/:id', verifyToken, checkPermission('deployment.run'), getById);

module.exports = router;
