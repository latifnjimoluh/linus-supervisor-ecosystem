const express = require('express');
const { askChatbot } = require('../../controllers/chatbot/chatbotController');

const router = express.Router();

router.post('/ask', askChatbot);

module.exports = router;
