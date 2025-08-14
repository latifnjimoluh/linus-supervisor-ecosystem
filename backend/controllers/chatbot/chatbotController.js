const { nanoid } = require("nanoid");
const { withTimeout, buildPrompt, parseRetryAfterSec } = require("../../utils/chatbot");

function createChatbotController({ model, systemPrompt, logChat }) {
  const REQUEST_TIMEOUT_MS = Number(process.env.REQUEST_TIMEOUT_MS || 45000);

  // Contrôleur principal : conversation simple
  const ask = async (req, res) => {
    const started = Date.now();
    const rid = req.id || nanoid(10);
    res.setHeader("x-rid", rid);

    try {
      const { messages = [] } = req.body || {};
      if (!Array.isArray(messages) || messages.length === 0) {
        return res.status(400).json({ error: "messages[] requis" });
      }

      // Construit le prompt avec règles de recadrage vers le projet BUNEC
      const { safe, prompt } = buildPrompt(messages, systemPrompt);

      // Appel modèle (pas de stream)
      const result = await withTimeout(model.generateContent(prompt), REQUEST_TIMEOUT_MS);
      const text =
        result?.response?.text?.() ||
        "Désolé, je n'ai pas pu générer de réponse.";

      const durationMs = Date.now() - started;

      // Log optionnel
      try {
        logChat?.({
          rid,
          t: new Date().toISOString(),
          ip: req.ip,
          durationMs,
          ok: true,
          mode: "plain",
          qChars: safe?.[safe.length - 1]?.content?.length || 0,
          aChars: text.length,
        });
      } catch {}

      return res.json({ reply: text, meta: { durationMs, rid } });
    } catch (err) {
      const durationMs = Date.now() - started;

      if (err?.status === 429 || /quota|Too Many Requests/i.test(String(err?.message))) {
        return res
          .status(429)
          .json({ error: "quota_exceeded", retryAfterSec: parseRetryAfterSec(err), rid, durationMs });
      }
      if (err?.message === "timeout") {
        return res.status(504).json({ error: "LLM_error", rid, durationMs });
      }

      req.log?.error?.({ err, rid }, "chatbot_error");
      return res.status(500).json({ error: "LLM_error", rid, durationMs });
    }
  };

  return { ask };
}

module.exports = { createChatbotController };
