import client from '../client';

export function sendMessage(message) {
  return client.post('/assistant/chat', { message }).then((res) => res.data);
}
