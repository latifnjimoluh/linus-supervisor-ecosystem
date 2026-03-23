// routes/chatbot/chatbotRoutes.js
const express = require("express");
const router = express.Router();

const { verifyToken, checkPermission } = require("../../middlewares/auth");
const { createGeminiModel } = require("../../services/chatbotModel");

const createAskRouter = require("../../controllers/chatbot/ask");
const createAskStreamRouter = require("../../controllers/chatbot/askStream");

// Init modèle & prompt
const model = createGeminiModel();
const systemPrompt =
  process.env.CHATBOT_SYSTEM_PROMPT ||
  "Tu es l’assistant IA du projet BUNEC. Réponds clairement, en français, concis, pratique. Recadre le hors-sujet vers le projet.";
const logChat = (e) => { if (process.env.NODE_ENV !== "test") console.log("[chatbot]", e); };

// Sécurité commune (auth + permission) sur tout /chatbot/*
router.use(
  "/",
  (req, _res, next) => { req.log?.info?.({ path: req.path }, "chatbot_request"); next(); },
  verifyToken,
  (req, _res, next) => { req.log?.info?.({ userId: req.user?.id, perms: req.user?.permissions }, "auth_ok"); next(); },
  checkPermission("chatbot.use"),
  express.json({ limit: "1mb" })
);

// Sous‑routeurs
router.use("/ask", createAskRouter({ model, systemPrompt, logChat }));
router.use("/ask/stream", createAskStreamRouter({ model, systemPrompt, logChat }));

// (optionnel) compat legacy: POST /chatbot -> /chatbot/ask
router.post("/", (req, res, next) => {
  req.url = "/"; // redirige vers /ask
  next();
}, createAskRouter({ model, systemPrompt, logChat }));

module.exports = router;
