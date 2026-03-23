// services/chatbotModel.js
const { GoogleGenerativeAI } = require("@google/generative-ai");

function createGeminiModel() {
  const apiKey = process.env.GEMINI_API_KEY || "";
  const MODEL_ID = process.env.MODEL_ID || "gemini-1.5-flash";
  const MODEL_FALLBACK_ID = process.env.MODEL_FALLBACK_ID || ""; // ex: "gemini-1.5-flash-8b"

  const genAI = new GoogleGenerativeAI(apiKey);
  const modelPrimary = genAI.getGenerativeModel({ model: MODEL_ID });
  const modelFallback = MODEL_FALLBACK_ID
    ? genAI.getGenerativeModel({ model: MODEL_FALLBACK_ID })
    : null;

  return {
    async generateContent(prompt) {
      try {
        return await modelPrimary.generateContent(prompt);
      } catch (err) {
        const msg = String(err?.message || "");
        if ((err?.status === 429 || /Too Many Requests|quota/i.test(msg)) && modelFallback) {
          return await modelFallback.generateContent(prompt);
        }
        throw err;
      }
    },
    async generateContentStream(prompt) {
      try {
        return await modelPrimary.generateContentStream(prompt);
      } catch (err) {
        const msg = String(err?.message || "");
        if ((err?.status === 429 || /Too Many Requests|quota/i.test(msg)) && modelFallback) {
          return await modelFallback.generateContentStream(prompt);
        }
        throw err;
      }
    },
  };
}

module.exports = { createGeminiModel };
