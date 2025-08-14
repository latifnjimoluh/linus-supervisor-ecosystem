import { getAuthToken, refreshAuthToken } from "@/services/api";

export async function streamChat(
  message: string,
  onToken: (token: string) => void
): Promise<void> {
  let token = getAuthToken();
  if (!token) token = await refreshAuthToken();
  if (!token) throw new Error("auth");

  const res = await fetch(`/chat/stream?message=${encodeURIComponent(message)}`, {
    headers: {
      Accept: "text/event-stream",
      Authorization: `Bearer ${token}`,
    },
  });

  if (!res.ok || !res.body) throw new Error("network");
  const reader = res.body.getReader();
  const decoder = new TextDecoder();
  let buffer = "";

  while (true) {
    const { value, done } = await reader.read();
    if (done) break;
    buffer += decoder.decode(value, { stream: true });
    let idx;
    while ((idx = buffer.indexOf("\n\n")) !== -1) {
      const part = buffer.slice(0, idx).trim();
      buffer = buffer.slice(idx + 2);
      if (!part.startsWith("data:")) continue;
      const data = part.slice(5).trim();
      if (data === "[DONE]") return;
      onToken(data);
    }
  }
}
