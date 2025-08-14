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

/** Réponse de l'API chatbot (mode non-stream) */
export interface AskResponse {
  reply: string;
  meta: { rid: string; durationMs: number };
}

const CHATBOT_URL = "/chatbot";
const CHATBOT_STREAM_URL = "/chatbot/stream";

/** Appel simple (pas de streaming) */
export async function askChatbot(
  messages: Array<Pick<ChatMessage, "role" | "content">>
): Promise<AskResponse> {
  const res = await api.post(CHATBOT_URL, { messages });
  return res.data as AskResponse;
}

/** Paquet SSE envoyé par le backend */
type ChatbotSSEPacket =
  | { meta?: any; delta?: string; done?: boolean }
  | { error: string; retryAfterSec?: number; info?: string };

/** Callbacks pour le streaming */
export interface StreamHandlers {
  onDelta: (piece: string) => void;
  onDone?: (full: string, meta?: any) => void;
  onError?: (err: any) => void;
}

/** Streaming via fetch + ReadableStream */
export async function askChatbotStream(
  messages: Array<Pick<ChatMessage, "role" | "content">>,
  { onDelta, onDone, onError }: StreamHandlers
): Promise<() => void> {
  const token =
    typeof window !== "undefined" ? localStorage.getItem("token") : null;
  const controller = new AbortController();
  let full = "";

  try {
    const resp = await fetch(resolveAbsoluteUrl(CHATBOT_STREAM_URL), {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        ...(token ? { Authorization: `Bearer ${token}` } : {}),
      },
      body: JSON.stringify({ messages }),
      signal: controller.signal,
    });

    if (!resp.ok || !resp.body) {
      const err = new Error(`HTTP ${resp.status}`);
      onError?.(err);
      return () => controller.abort();
    }

    const reader = resp.body.getReader();
    const decoder = new TextDecoder("utf-8");
    let buffer = "";

    const readLoop = async () => {
      while (true) {
        const { done, value } = await reader.read();
        if (done) break;

        buffer += decoder.decode(value, { stream: true });

        let boundary;
        while ((boundary = buffer.indexOf("\n\n")) !== -1) {
          const packet = buffer.slice(0, boundary);
          buffer = buffer.slice(boundary + 2);

          if (packet.startsWith(":")) continue;

          const lines = packet.split("\n");
          for (const line of lines) {
            if (!line.startsWith("data:")) continue;
            const payload = line.slice(5).trim();
            if (!payload) continue;

            let obj: ChatbotSSEPacket | null = null;
            try { obj = JSON.parse(payload); } catch { continue; }

            if ((obj as any)?.error) {
              onError?.(obj);
              controller.abort();
              return;
            }

            if ((obj as any)?.delta) {
              const piece = (obj as any).delta as string;
              full += piece;
              onDelta(piece);
            }

            if ((obj as any)?.done) {
              const meta = (obj as any).meta;
              onDone?.(full, meta);
              controller.abort();
              return;
            }
          }
        }
      }
      onDone?.(full);
    };

    readLoop().catch((e) => onError?.(e));
  } catch (e) {
    onError?.(e);
  }

  return () => controller.abort();
}

function resolveAbsoluteUrl(path: string): string {
  const base =
    (typeof window !== "undefined" && (window as any)?.__API_BASE_URL__) ||
    process.env.NEXT_PUBLIC_API_BASE_URL ||
    "";
  if (!base) return path;
  return `${trimSlash(base)}/${trimSlash(path)}`;
}

function trimSlash(s: string) {
  return s.replace(/^\/+|\/+$/g, "");
}
