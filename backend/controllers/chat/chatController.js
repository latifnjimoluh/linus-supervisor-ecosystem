const { GoogleGenerativeAI } = require('@google/generative-ai');
const { ChatConversation, ChatMessage } = require('../../models');
const { record: recordChatMetric } = require('../../utils/chatMetrics');

const apiKey = process.env.GEMINI_API_KEY;
const useGemini = process.env.USE_GEMINI === 'true';
const MAX_INPUT_CHARS = 8000;
const MAX_HISTORY_MESSAGES = 20;
const DEFAULT_SYSTEM_PROMPT =
  'Tu es un assistant IA qui fournit analyses et recommandations, pas seulement des descriptions. Réponds toujours en français.';

const DANGEROUS_PATTERNS = [
  /<[^>]*>/g, // remove HTML tags
  /script/gi,
  /eval\s*\(/gi,
  /exec\s*\(/gi,
  /system\s*\(/gi,
  /spawn\s*\(/gi,
  /process/gi,
  /require\s*\(/gi,
];

function sanitizeText(text = '') {
  return DANGEROUS_PATTERNS.reduce((acc, pattern) => acc.replace(pattern, ''), text);
}

async function summarizeOldMessages(convo, toSummarize) {
  if (!toSummarize.length) return;
  if (!apiKey) return;
  try {
    const genAI = new GoogleGenerativeAI(apiKey);
    const model = genAI.getGenerativeModel({ model: 'gemini-1.5-flash' });
    const content = toSummarize
      .map((m) => `${m.role}: ${m.content}`)
      .join('\n');
    const prompt =
      'Résume en français de manière concise les échanges suivants pour conserver le contexte :\n' +
      content;
    const result = await model.generateContent(prompt);
    const summary = sanitizeText(result.response.text());
    const newSummary = (convo.summary ? `${convo.summary}\n` : '') + summary;
    await ChatConversation.update({ summary: newSummary }, { where: { id: convo.id } });
    convo.summary = newSummary;
    const ids = toSummarize.map((m) => m.id);
    await ChatMessage.destroy({ where: { id: ids } });
  } catch (err) {
    console.error('summarizeOldMessages error', err);
  }
}

async function getRecentMessages(convo) {
  let messages = await ChatMessage.findAll({
    where: { conversation_id: convo.id },
    order: [['created_at', 'ASC']],
  });
  if (messages.length > MAX_HISTORY_MESSAGES) {
    const excess = messages.slice(0, messages.length - MAX_HISTORY_MESSAGES);
    await summarizeOldMessages(convo, excess);
    messages = await ChatMessage.findAll({
      where: { conversation_id: convo.id },
      order: [['created_at', 'ASC']],
    });
  }
  return messages;
}

function mapGeminiError(err) {
  const status = err?.status || err?.response?.status;
  if (status === 401 || status === 403) {
    return { status: 503, message: 'Service IA non disponible (auth)' };
  }
  if (status === 429) {
    return { status: 429, message: 'Quota atteint — réessayez plus tard' };
  }
  if (status >= 500 && status < 600) {
    return { status: 503, message: 'Service IA indisponible' };
  }
  return { status: 500, message: 'Gemini API error' };
}

const createConversation = async (req, res) => {
  try {
    const convo = await ChatConversation.create({
      user_id: req.user.id,
      system_prompt: DEFAULT_SYSTEM_PROMPT,
    });
    return res.status(201).json({ conversation_id: convo.id });
  } catch (err) {
    console.error('createConversation error', err);
    return res.status(500).json({ error: 'Failed to create conversation' });
  }
};

const streamMessage = async (req, res) => {
  const { conversation_id, user_text } = req.body || {};
  if (!conversation_id || !user_text) {
    return res.status(400).json({ error: 'conversation_id and user_text required' });
  }
  if (user_text.length > MAX_INPUT_CHARS) {
    return res.status(400).json({ error: 'Input too long' });
  }
  const start = Date.now();
  if (!useGemini || !apiKey) {
    try {
      const convo = await ChatConversation.findOne({ where: { id: conversation_id, user_id: req.user.id } });
      if (!convo) {
        return res.status(404).json({ error: 'Conversation not found' });
      }
      const clean = sanitizeText(user_text);
      await ChatMessage.create({ conversation_id, role: 'user', content: clean });
      const reply = `Gemini désactivé : ${clean}`;
      await ChatMessage.create({ conversation_id, role: 'assistant', content: reply });
      res.setHeader('Content-Type', 'text/event-stream');
      res.setHeader('Cache-Control', 'no-cache');
      res.setHeader('Connection', 'keep-alive');
      res.write(`event: message\n`);
      res.write(`data: ${JSON.stringify({ delta: reply })}\n\n`);
      res.write('event: end\n\n');
      res.end();
      const duration = Date.now() - start;
      recordChatMetric({ success: true, durationMs: duration, tokens: reply.length });
    } catch (err) {
      const duration = Date.now() - start;
      recordChatMetric({ success: false, durationMs: duration, errorType: err.message });
      res.status(500).json({ error: 'Failed to send message' });
    }
    return;
  }
  try {
    const convo = await ChatConversation.findOne({ where: { id: conversation_id, user_id: req.user.id } });
    if (!convo) {
      return res.status(404).json({ error: 'Conversation not found' });
    }

    const clean = sanitizeText(user_text);
    await ChatMessage.create({ conversation_id, role: 'user', content: clean });
    const messages = await getRecentMessages(convo);
    const historyMsgs = messages.slice(0, -1);
    const history = historyMsgs.map((m) => ({
      role: m.role === 'assistant' ? 'model' : 'user',
      parts: [{ text: m.content }],
    }));
    const prompt = messages[messages.length - 1].content;

    const genAI = new GoogleGenerativeAI(apiKey);
    const model = genAI.getGenerativeModel({ model: 'gemini-1.5-flash' });
    const chatSession = model.startChat({
      history,
      systemInstruction: {
        parts: [
          {
            text:
              convo.system_prompt +
              (convo.summary ? `\nContexte précédent : ${convo.summary}` : ''),
          },
        ],
      },
    });
    const result = await chatSession.sendMessageStream(prompt);

    res.setHeader('Content-Type', 'text/event-stream');
    res.setHeader('Cache-Control', 'no-cache');
    res.setHeader('Connection', 'keep-alive');

    const timeout = setTimeout(() => {
      if (!res.writableEnded) {
        res.write('event: error\n');
        res.write(`data: ${JSON.stringify({ error: 'timeout' })}\n\n`);
        res.write('event: end\n\n');
        res.end();
      }
    }, 120000);
    req.on('close', () => clearTimeout(timeout));

    let full = '';
    for await (const chunk of result.stream) {
      const delta = sanitizeText(chunk.text());
      full += delta;
      res.write(`event: message\n`);
      res.write(`data: ${JSON.stringify({ delta })}\n\n`);
    }
    res.write('event: end\n\n');
    res.end();

    const usage = await result.response;
    const tokens = usage?.usageMetadata?.totalTokenCount || 0;
    await ChatMessage.create({ conversation_id, role: 'assistant', content: full });
    const duration = Date.now() - start;
    console.log('chat_request', {
      user_id: req.user.id,
      conversation_id,
      duration_ms: duration,
      tokens,
    });
    recordChatMetric({ success: true, durationMs: duration, tokens });
  } catch (err) {
    const duration = Date.now() - start;
    console.error('streamMessage error', err);
    const { status, message } = mapGeminiError(err);
    recordChatMetric({ success: false, durationMs: duration, errorType: message });
    if (!res.headersSent) {
      return res.status(status).json({ error: message });
    }
    res.write(`event: error\n`);
    res.write(`data: ${JSON.stringify({ error: message })}\n\n`);
    res.write('event: end\n\n');
    res.end();
  }
};

const getConversation = async (req, res) => {
  try {
    const { id } = req.params;
    const page = parseInt(req.query.page, 10) || 1;
    const limit = parseInt(req.query.limit, 10) || 20;
    const offset = (page - 1) * limit;

    const convo = await ChatConversation.findOne({ where: { id, user_id: req.user.id } });
    if (!convo) {
      return res.status(404).json({ error: 'Conversation not found' });
    }
    const { rows: messages, count } = await ChatMessage.findAndCountAll({
      where: { conversation_id: id },
      order: [['created_at', 'ASC']],
      limit,
      offset,
    });
    res.json({
      conversation: { id: convo.id, system_prompt: convo.system_prompt, summary: convo.summary },
      messages,
      pagination: { page, limit, total: count },
    });
  } catch (err) {
    console.error('getConversation error', err);
    res.status(500).json({ error: 'Failed to fetch conversation' });
  }
};

module.exports = { createConversation, streamMessage, getConversation };
