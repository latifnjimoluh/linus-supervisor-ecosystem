const express = require('express');
const {
  askChatbot,
  modelPrimary,
  SYSTEM_PROMPT,
} = require('../../controllers/chatbot/chatbotController');
const createAskStreamRouter = require('./askStream');

const router = express.Router();

router.post('/ask', askChatbot);

if (modelPrimary) {
  router.use(
    '/ask/stream',
    createAskStreamRouter({ model: modelPrimary, SYSTEM_PROMPT })
  );
}

module.exports = router;
