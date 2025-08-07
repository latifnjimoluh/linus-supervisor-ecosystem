import client from '../client';

export const listMonitoring = (params) =>
  client.get('/monitoring', { params });

export const getMonitoring = (id) => client.get(`/monitoring/${id}`);

export const overview = () => client.get('/monitoring/overview');

export const collectData = (data) => client.post('/monitoring/collect', data);

export const syncDeploymentIp = (data) =>
  client.post('/monitoring/sync-ip', data);
