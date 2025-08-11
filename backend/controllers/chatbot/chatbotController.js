const asyncHandler = require('express-async-handler');

let GoogleGenerativeAI;
try {
  ({ GoogleGenerativeAI } = require('@google/generative-ai'));
} catch (err) {
  GoogleGenerativeAI = null;
}

const SYSTEM_PROMPT =
  'Tu es assistant BUNEC. Réponds en français, techniquement et de façon concise, ' +
  'avec des étapes actionnables (DevOps, Linux, Terraform, Proxmox, supervision, sécurité). ' +
  'Si la question sort du périmètre, réponds brièvement puis recadre vers le projet.';

const genAI = GoogleGenerativeAI ? new GoogleGenerativeAI(process.env.GEMINI_API_KEY || '') : null;
const MODEL_ID = process.env.MODEL_ID || 'gemini-1.5-flash';
const MODEL_FALLBACK_ID = process.env.MODEL_FALLBACK_ID || '';
const modelPrimary = genAI ? genAI.getGenerativeModel({ model: MODEL_ID }) : null;
const modelFallback = genAI && MODEL_FALLBACK_ID ? genAI.getGenerativeModel({ model: MODEL_FALLBACK_ID }) : null;

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

    const { prompt } = buildPrompt(messages, SYSTEM_PROMPT);
    const timeoutMs = Number(process.env.REQUEST_TIMEOUT_MS || 45000);

    const result = await withTimeout(generateContent(prompt), timeoutMs);
    const text =
      result?.response?.text?.() ||
      "Désolé, je n'ai pas pu générer de réponse.";

    const durationMs = Date.now() - started;
    return res.json({ reply: text, meta: { durationMs, rid } });
  } catch (err) {
    const durationMs = Date.now() - started;
    if (err?.status === 429 || /quota|Too Many Requests/i.test(String(err?.message))) {
      return res
        .status(429)
        .json({ error: 'quota_exceeded', retryAfterSec: parseRetryAfterSec(err), rid, durationMs });
    }
    if (err?.message === 'timeout') {
      return res.status(504).json({ error: 'LLM_error', rid, durationMs });
    }
    return res.status(500).json({ error: 'LLM_error', rid, durationMs });
  }
});

