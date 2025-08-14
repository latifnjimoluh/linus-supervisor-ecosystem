// services/chatbot.ts
import { api } from "./api";

/** Rôles autorisés pour le chatbot */
export type ChatRole = "user" | "assistant";

/** Message affiché dans l’UI */
export interface ChatMessage {
  id: string;
  role: ChatRole;
  content: string;
}

/** Réponse de l'API chatbot */
export interface AskResponse {
  reply: string;
  meta: { rid: string; durationMs: number };
}

/**
 * Envoie l'historique des messages au backend chatbot
 * NB: adapte l'URL ci-dessous selon ton montage backend:
 *  - si routes montées sur app.use("/chatbot", ...):  api.post("/chatbot", ...)
 *  - si montées sur "/api/chatbot":                   api.post("/api/chatbot", ...)
 */
export async function askChatbot(
  messages: Array<Pick<ChatMessage, "role" | "content">>
): Promise<AskResponse> {
  const res = await api.post("/chatbot", { messages });
  return res.data as AskResponse;
}
