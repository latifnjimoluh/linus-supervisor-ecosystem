// services/chatbotModel.js
const { GoogleGenerativeAI } = require("@google/generative-ai");

function createGeminiModel() {
  const apiKey = process.env.GEMINI_API_KEY;
  if (!apiKey) {
    throw new Error("GEMINI_API_KEY manquant dans l'environnement");
  }

  const modelName = process.env.CHATBOT_MODEL || "gemini-1.5-flash";
  const genAI = new GoogleGenerativeAI(apiKey);
  const model = genAI.getGenerativeModel({ model: modelName });

  // On expose 2 méthodes homogènes pour le controller
  return {
    async generate(prompt) {
      // prompt texte (transcript)
      return model.generateContent(prompt);
    },
    async stream(prompt) {
      // stream SSE
      return model.generateContentStream({
        contents: [{ role: "user", parts: [{ text: prompt }] }],
      });
    },
  };
}

module.exports = { createGeminiModel };
