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

export async function askChatbotStream(
  messages: ChatMessage[],
  onToken: (token: string) => void
): Promise<void> {
  const res = await fetch(`${api.defaults.baseURL}/chatbot/ask/stream`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ messages }),
  });

  if (!res.body) {
    throw new Error("No stream returned");
  }

  const reader = res.body.getReader();
  const decoder = new TextDecoder();
  let buffer = "";

  while (true) {
    const { value, done } = await reader.read();
    if (done) break;
    buffer += decoder.decode(value, { stream: true });
    const lines = buffer.split("\n");
    buffer = lines.pop() || "";
    for (const line of lines) {
      const trimmed = line.trim();
      if (trimmed.startsWith("data:")) {
        const data = trimmed.slice(5).trim();
        if (!data) continue;
        try {
          const obj = JSON.parse(data);
          if (obj.delta) onToken(obj.delta);
          if (obj.done) return;
          if (obj.error) throw new Error(obj.error);
        } catch (err) {
          // ignore malformed JSON
        }
      }
    }
  }
}
