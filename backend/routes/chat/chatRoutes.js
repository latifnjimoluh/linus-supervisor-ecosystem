const express = require('express');
const { createConversation, streamMessage, getConversation } = require('../../controllers/chat/chatController');
const { verifyToken } = require('../../middlewares/auth');
const { logRequest } = require('../../middlewares/log');
const chatRateLimiter = require('../../middlewares/chatRateLimiter');

const router = express.Router();

router.use(verifyToken, logRequest);

router.post('/conversations', createConversation);
router.post('/messages\:stream', chatRateLimiter({ windowMs: 300000, limit: 30 }), streamMessage);
router.get('/conversations/:id', getConversation);

module.exports = router;
