const asyncHandler = require('express-async-handler');

let GoogleGenerativeAI;
try {
  ({ GoogleGenerativeAI } = require('@google/generative-ai'));
} catch (err) {
  GoogleGenerativeAI = null;
}

const { fetchContext } = require('../../services/ragService');

const SYSTEM_PROMPT =
  'Tu es assistant BUNEC. Réponds en français, techniquement et de façon concise, ' +
  'avec des étapes actionnables (DevOps, Linux, Terraform, Proxmox, supervision, sécurité). ' +
  'Si la question sort du périmètre, réponds brièvement puis recadre vers le projet.';

const genAI = GoogleGenerativeAI ? new GoogleGenerativeAI(process.env.GEMINI_API_KEY || '') : null;
const MODEL_ID = process.env.MODEL_ID || 'gemini-1.5-flash';
const MODEL_FALLBACK_ID = process.env.MODEL_FALLBACK_ID || '';
const modelPrimary = genAI ? genAI.getGenerativeModel({ model: MODEL_ID }) : null;
const modelFallback = genAI && MODEL_FALLBACK_ID ? genAI.getGenerativeModel({ model: MODEL_FALLBACK_ID }) : null;

exports.SYSTEM_PROMPT = SYSTEM_PROMPT;
exports.modelPrimary = modelPrimary;

async function generateContent(prompt) {
  if (!modelPrimary) throw new Error('LLM_not_configured');
  try {
    return await modelPrimary.generateContent(prompt);
  } catch (err) {
    const msg = String(err?.message || '');
    if ((err?.status === 429 || /Too Many Requests|quota/i.test(msg)) && modelFallback) {
      return await modelFallback.generateContent(prompt);
    }
    throw err;
  }
}

const withTimeout = (p, ms) =>
  Promise.race([
    p,
    new Promise((_, rej) => setTimeout(() => rej(new Error('timeout')), ms)),
  ]);

const stripControlTokens = (s = '') =>
  String(s)
    .replace(/^\s*(SYSTEM|ASSISTANT|USER)\s*:\s*/gim, '')
    .slice(0, 4000);

const buildPrompt = (messages = [], SYSTEM_PROMPT = '') => {
  const safe = (Array.isArray(messages) ? messages : [])
    .slice(-15)
    .map((m) => ({
      role: m?.role === 'assistant' ? 'assistant' : 'user',
      content: stripControlTokens(m?.content || ''),
    }))
    .filter((m) => m.content.trim().length > 0);

  const SCOPE_RULES =
    'Si la question sort du périmètre (BUNEC, DevOps, Linux, Terraform, Proxmox, supervision, sécurité), ' +
    "réponds brièvement que ce n’est pas couvert puis recadre vers le projet.";

  const prompt =
    `SYSTEM:\n${SYSTEM_PROMPT}\n\nRÈGLES:\n${SCOPE_RULES}\n\n` +
    safe.map((m) => `${m.role.toUpperCase()}: ${m.content}`).join('\n') +
    `\nASSISTANT:`;

  return { safe, prompt };
};

function parseRetryAfterSec(err) {
  try {
    const arr = err?.errorDetails || [];
    for (const item of arr) {
      if (String(item?.['@type'] || '').includes('RetryInfo')) {
        const s = String(item?.retryDelay || '').trim();
        const m = s.match(/^(\d+)\s*s?$/i);
        if (m) return Number(m[1]);
      }
    }
  } catch {}
  return null;
}

exports.askChatbot = asyncHandler(async (req, res) => {
  const started = Date.now();
  const rid = Date.now().toString();

  try {
    const { messages = [] } = req.body || {};
    if (!Array.isArray(messages) || messages.length === 0) {
      return res.status(400).json({ error: 'messages[] requis' });
    }

    const lastUser = messages
      .filter((m) => m?.role !== 'assistant')
      .slice(-1)[0]?.content;
    const context = await fetchContext(lastUser);
    const system = context
      ? `${SYSTEM_PROMPT}\n\nCONTEXTE:\n${context}`
      : SYSTEM_PROMPT;

    const { prompt } = buildPrompt(messages, system);
    const timeoutMs = Number(process.env.REQUEST_TIMEOUT_MS || 45000);

    const result = await withTimeout(generateContent(prompt), timeoutMs);
    const text =
      result?.response?.text?.() ||
      "Désolé, je n'ai pas pu générer de réponse.";

    const durationMs = Date.now() - started;

    const isStream =
      String(req.query.stream || req.body?.stream || '')
        .toLowerCase()
        .startsWith('t') ||
      String(req.query.stream || req.body?.stream || '') === '1';

    if (!isStream) {
      return res.json({ reply: text, meta: { durationMs, rid } });
    }

    res.setHeader('Content-Type', 'text/event-stream');
    res.setHeader('Cache-Control', 'no-cache');
    res.setHeader('Connection', 'keep-alive');
    res.flushHeaders?.();

    const splitMode = (process.env.STREAM_SPLIT || 'word').toLowerCase();
    const delayMs = Number(process.env.STREAM_DELAY_MS || 0);
    const heartbeatMs = Number(process.env.STREAM_HEARTBEAT_MS || 0);

    const splitText = (s = '') => {
      if (splitMode === 'char') return s.split('');
      if (splitMode === 'word') return s.match(/\S+\s*/g) || [];
      return [s];
    };

    let heartbeat;
    if (heartbeatMs > 0) {
      heartbeat = setInterval(() => {
        res.write(':heartbeat\n\n');
      }, heartbeatMs);
    }

    for (const part of splitText(text)) {
      res.write(`data: ${part}\n\n`);
      if (delayMs > 0) {
        await new Promise((r) => setTimeout(r, delayMs));
      }
    }

    res.write('data: [DONE]\n\n');
    if (heartbeat) clearInterval(heartbeat);
    res.end();
  } catch (err) {
    const durationMs = Date.now() - started;
    if (err?.status === 429 || /quota|Too Many Requests/i.test(String(err?.message))) {
      if (!res.headersSent) {
        return res
          .status(429)
          .json({ error: 'quota_exceeded', retryAfterSec: parseRetryAfterSec(err), rid, durationMs });
      }
      res.end();
      return;
    }
    if (err?.message === 'timeout') {
      if (!res.headersSent) return res.status(504).json({ error: 'LLM_error', rid, durationMs });
      res.end();
      return;
    }
    if (!res.headersSent) return res.status(500).json({ error: 'LLM_error', rid, durationMs });
    res.end();
  }
});

