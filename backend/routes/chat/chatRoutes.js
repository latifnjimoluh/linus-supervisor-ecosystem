const express = require('express');
const { stream } = require('../../controllers/chat/chatController');
const { verifyToken } = require('../../middlewares/auth');
const rateLimiter = require('../../middlewares/rateLimiter');

const router = express.Router();

router.get('/stream', verifyToken, rateLimiter({ limit: 60, windowMs: 60000 }), stream);
router.post("/ask", verifyToken, rateLimiter({ limit: 60, windowMs: 60000 }), stream);
module.exports = router;
