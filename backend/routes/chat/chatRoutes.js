const express = require('express');
const { chat } = require('../../controllers/chat/chatController');

const router = express.Router();
router.post('/', chat);

module.exports = router;
