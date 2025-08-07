const asyncHandler = require('express-async-handler');

// Simple echo-based assistant controller
exports.chatWithAssistant = asyncHandler(async (req, res) => {
  const { message } = req.body || {};
  if (!message) {
    return res.status(400).json({ error: 'Message requis' });
  }
  // Placeholder: in future integrate with real AI service
  const reply = `Assistant indisponible: vous avez dit "${message}"`;
  res.json({ reply });
});
