import client from './client';

export function getScript(serverId, service, format) {
  return client.get(`/scripts/preview/${serverId}/${service}`, { params: { format } });
}
