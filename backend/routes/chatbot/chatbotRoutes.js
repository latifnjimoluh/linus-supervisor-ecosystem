const express = require("express");
const router = express.Router();

const { verifyToken, checkPermission } = require("../../middlewares/auth");
const { createGeminiModel } = require("../../services/chatbotModel");
const { createChatbotController } = require("../../controllers/chatbot/chatbotController");

// Init modèle & contrôleur
const model = createGeminiModel();
const systemPrompt =
  process.env.CHATBOT_SYSTEM_PROMPT ||
  "Tu es l’assistant IA du projet BUNEC. Réponds clairement, en français, de façon concise et pratique, et recadre toute question hors sujet vers le contexte du projet.";
const logChat = (e) => {
  if (process.env.NODE_ENV !== "test") console.log("[chatbot]", e);
};

const controller = createChatbotController({ model, systemPrompt, logChat });

// Route POST /chatbot
router.post(
  "/",
  verifyToken,
  checkPermission("chatbot.use"),
  express.json({ limit: "1mb" }),
  controller.ask
);

module.exports = router;
