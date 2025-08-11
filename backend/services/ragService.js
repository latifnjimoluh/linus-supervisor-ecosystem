let GoogleGenerativeAI;
try {
  ({ GoogleGenerativeAI } = require('@google/generative-ai'));
} catch (err) {
  GoogleGenerativeAI = null;
}

const fs = require('fs');
const path = require('path');

const VECTOR_DIR = process.env.VECTOR_DIR || 'vectorstore';
const SEARCH_BACKEND = (process.env.SEARCH_BACKEND || 'json').toLowerCase();

const vectorPath = path.resolve(process.cwd(), VECTOR_DIR, 'index.json');
let vectorStore;

function loadVectorStore() {
  if (vectorStore) return vectorStore;
  try {
    const raw = fs.readFileSync(vectorPath, 'utf8');
    vectorStore = JSON.parse(raw);
  } catch (err) {
    vectorStore = [];
  }
  return vectorStore;
}

const genAI = GoogleGenerativeAI
  ? new GoogleGenerativeAI(process.env.GEMINI_API_KEY || '')
  : null;
const embedModel = genAI ? genAI.getGenerativeModel({ model: 'text-embedding-004' }) : null;

async function embedText(text) {
  if (!embedModel) return null;
  try {
    const result = await embedModel.embedContent(text);
    const vec = result?.embedding?.values || result?.data?.[0]?.embedding;
    return Array.isArray(vec) ? vec : null;
  } catch (err) {
    return null;
  }
}

function cosineSimilarity(a = [], b = []) {
  let dot = 0;
  let na = 0;
  let nb = 0;
  const len = Math.min(a.length, b.length);
  for (let i = 0; i < len; i++) {
    const x = a[i];
    const y = b[i];
    dot += x * y;
    na += x * x;
    nb += y * y;
  }
  return dot / (Math.sqrt(na) * Math.sqrt(nb) || 1);
}

async function fetchContext(query) {
  if (SEARCH_BACKEND !== 'json') return '';
  const q = String(query || '').trim();
  if (!q) return '';
  const store = loadVectorStore();
  if (!store.length) return '';
  const qVec = await embedText(q);
  if (!qVec) return '';
  const scored = store
    .map((d) => ({ ...d, score: cosineSimilarity(qVec, d.embedding || []) }))
    .sort((a, b) => b.score - a.score);

  const topK = Number(process.env.RAG_TOP_K || 3);
  const minScore = Number(process.env.RAG_MIN_SCORE || 0);
  const selected = scored.filter((d) => d.score >= minScore).slice(0, topK);
  const context = selected.map((d) => d.text || d.content || '').join('\n');
  const maxChars = Number(process.env.RAG_MAX_CONTEXT_CHARS || 8000);
  return context.slice(0, maxChars);
}

module.exports = {
  fetchContext,
};

