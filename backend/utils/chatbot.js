// Timeout global simple
function withTimeout(promise, ms) {
  return Promise.race([
    promise,
    new Promise((_, rej) => setTimeout(() => rej(new Error("timeout")), ms)),
  ]);
}

// Anti-injection basique + bornage
function stripControlTokens(s = "") {
  return String(s)
    .replace(/^\s*(SYSTEM|ASSISTANT|USER)\s*:\s*/gim, "")
    .slice(0, 4000);
}

// Build prompt façon transcript
function buildPrompt(messages = [], SYSTEM_PROMPT = "") {
  const safe = (Array.isArray(messages) ? messages : [])
    .slice(-15)
    .map((m) => ({
      role: m?.role === "assistant" ? "assistant" : "user",
      content: stripControlTokens(m?.content || ""),
    }))
    .filter((m) => m.content.trim().length > 0);

  const SCOPE_RULES =
    "Si la question sort du périmètre (BUNEC, DevOps, Linux, Terraform, Proxmox, supervision, sécurité), " +
    "réponds brièvement que ce n’est pas couvert puis recadre vers le projet.";

  const prompt =
    `SYSTEM:\n${SYSTEM_PROMPT}\n\nRÈGLES:\n${SCOPE_RULES}\n\n` +
    safe.map((m) => `${m.role.toUpperCase()}: ${m.content}`).join("\n") +
    `\nASSISTANT:`;

  return { safe, prompt };
}

// Parse retryAfter depuis l'erreur LLM
function parseRetryAfterSec(err) {
  try {
    const arr = err?.errorDetails || [];
    for (const item of arr) {
      if (String(item?.["@type"] || "").includes("RetryInfo")) {
        const s = String(item?.retryDelay || "").trim();
        const m = s.match(/^(\d+)\s*s?$/i);
        if (m) return Number(m[1]);
      }
    }
  } catch {}
  return null;
}

module.exports = { withTimeout, buildPrompt, parseRetryAfterSec };
