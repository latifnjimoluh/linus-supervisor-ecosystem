import { apiUrl, getAuthToken } from './api';

export async function createConversation(): Promise<number> {
  const token = getAuthToken();
  const res = await fetch(`${apiUrl}/chat/conversations`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      ...(token ? { Authorization: `Bearer ${token}` } : {}),
    },
  });
  if (!res.ok) {
    const text = await res.text().catch(() => '');
    throw new Error(text || 'Conversation error');
  }
  const data = await res.json();
  return data.conversation_id;
}

export async function streamChatMessage(
  conversationId: number,
  userText: string,
  onChunk: (chunk: string) => void,
  signal?: AbortSignal
): Promise<void> {
  const token = getAuthToken();
  const res = await fetch(`${apiUrl}/chat/messages:stream`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      ...(token ? { Authorization: `Bearer ${token}` } : {}),
    },
    body: JSON.stringify({ conversation_id: conversationId, user_text: userText }),
    signal,
  });
  if (!res.ok) {
    const text = await res.text().catch(() => '');
    throw new Error(text || 'Chat API error');
  }

  const contentType = res.headers.get('content-type') || '';
  if (contentType.includes('application/json')) {
    const data = await res.json();
    onChunk(data.reply ?? '');
    return;
  }

  if (!res.body) {
    throw new Error('Chat API error');
  }

  const reader = res.body.getReader();
  const decoder = new TextDecoder();
  let buffer = '';
  try {
    while (true) {
      const { value, done } = await reader.read();
      if (done) break;
      buffer += decoder.decode(value, { stream: true });
      let boundary;
      while ((boundary = buffer.indexOf('\n\n')) !== -1) {
        const piece = buffer.slice(0, boundary);
        buffer = buffer.slice(boundary + 2);
        const match = piece.match(/^(?:event: (.+)\n)?data: (.*)$/s);
        if (!match) continue;
        const [, event = 'message', data] = match;
        if (event === 'message') {
          const parsed = JSON.parse(data);
          onChunk(parsed.delta);
        } else if (event === 'error') {
          const parsed = JSON.parse(data);
          throw new Error(parsed.error || 'Chat error');
        } else if (event === 'end') {
          return;
        }
      }
    }
  } catch (err: any) {
    if (err.name === 'AbortError') return;
    throw err;
  }
}

export async function fetchConversation(id: number): Promise<ChatMessage[]> {
  const token = getAuthToken();
  const res = await fetch(`${apiUrl}/chat/conversations/${id}`, {
    headers: {
      'Content-Type': 'application/json',
      ...(token ? { Authorization: `Bearer ${token}` } : {}),
    },
  });
  if (!res.ok) {
    const text = await res.text().catch(() => '');
    throw new Error(text || 'Conversation fetch error');
  }
  const data = await res.json();
  return data.messages.map((m: any) => ({ role: m.role, content: m.content }));
}

export interface ChatMessage {
  role: 'user' | 'assistant';
  content: string;
}
