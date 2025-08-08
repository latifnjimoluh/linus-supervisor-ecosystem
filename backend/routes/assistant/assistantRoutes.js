const express = require('express');
const router = express.Router();
const { chatWithAssistant } = require('../../controllers/assistant/assistantController');

router.post('/chat', chatWithAssistant);

module.exports = router;
