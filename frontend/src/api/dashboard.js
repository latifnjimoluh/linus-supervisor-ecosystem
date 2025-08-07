import client from './client';

export function getDashboardSummary() {
  return client.get('/dashboard/summary');
}

export function listServers() {
  return client.get('/dashboard/servers');
}
