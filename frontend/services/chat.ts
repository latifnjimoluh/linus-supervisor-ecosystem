import { api } from './api';

export async function sendMessage(message: string): Promise<string> {
  const res = await api.post('/chat', { message });
  return res.data.reply as string;
}
