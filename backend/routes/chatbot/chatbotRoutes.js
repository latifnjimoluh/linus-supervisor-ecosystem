const express = require('express');
const {
  askChatbot,
  modelPrimary,
  SYSTEM_PROMPT,
} = require('../../controllers/chatbot/chatbotController');
const createAskStreamRouter = require('./askStream');
const { verifyToken } = require('../../middlewares/auth');

const router = express.Router();

router.post('/ask', verifyToken, askChatbot);

if (modelPrimary) {
  router.use(
    '/ask/stream',
    verifyToken,
    createAskStreamRouter({ model: modelPrimary, SYSTEM_PROMPT })
  );
}

module.exports = router;
