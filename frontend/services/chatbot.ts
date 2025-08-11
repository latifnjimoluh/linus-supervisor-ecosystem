import { api } from "./api";

export interface ChatMessage {
  role: "user" | "assistant";
  content: string;
}

export interface ChatbotReply {
  reply: string;
  meta?: any;
}

export async function askChatbot(messages: ChatMessage[]): Promise<ChatbotReply> {
  const res = await api.post("/chatbot/ask", { messages });
  return res.data as ChatbotReply;
}
