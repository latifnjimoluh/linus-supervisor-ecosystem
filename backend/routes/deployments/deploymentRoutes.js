const express = require('express');
const router = express.Router();
const { verifyToken, checkPermission } = require('../../middlewares/auth');
const { getById } = require('../../controllers/deployments/deploymentController');
const { stream } = require("../../controllers/deployments/stream");

router.get("/:id/stream", stream);
router.get('/:id', verifyToken, checkPermission('deployment.run'), getById);

module.exports = router;
