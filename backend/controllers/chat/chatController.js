const asyncHandler = require('express-async-handler');
const logger = require('../../utils/logger');

const history = new Map(); // key: userId:threadId -> [{role, content}]

function safeMessage(input = '') {
  return String(input).replace(/^\s*system:\s*/i, '').slice(0, 4000);
}

exports.stream = asyncHandler(async (req, res) => {
  const userId = req.user?.id || 'anon';
  const threadId = String(req.query?.threadId || 'default');
  const message = safeMessage(String(req.query?.message || ''));

  if (!message) {
    return res.status(400).json({ error: 'message_requis' });
  }

  const key = `${userId}:${threadId}`;
  const msgs = history.get(key) || [];
  msgs.push({ role: 'user', content: message });
  history.set(key, msgs);

  res.setHeader('Content-Type', 'text/event-stream');
  res.setHeader('Cache-Control', 'no-cache');
  res.setHeader('Connection', 'keep-alive');
  res.flushHeaders?.();

  const controller = new AbortController();
  req.on('close', () => controller.abort());

  let full = '';
  const started = Date.now();
  const ping = setInterval(() => {
    try {
      res.write(':\n\n');
    } catch {}
  }, 20000);

  try {
    await streamChat({
      messages: msgs,
      signal: controller.signal,
      onDelta: (token) => {
        full += token;
        try {
          res.write(`data: ${token}\n\n`);
        } catch {
          controller.abort();
        }
      },
    });
    msgs.push({ role: 'assistant', content: full });
    history.set(key, msgs);
    const durationMs = Date.now() - started;
    logger.info('chat_stream', {
      userId,
      threadId,
      promptChars: message.length,
      responseChars: full.length,
      durationMs,
      status: 'success',
    });
    try {
      res.write('data: [DONE]\n\n');
    } catch {}
  } catch (err) {
    logger.error('chat_stream_error', { userId, threadId, err: err.message });
  } finally {
    clearInterval(ping);
    res.end();
  }
});
