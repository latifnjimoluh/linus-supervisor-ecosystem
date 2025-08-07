import client from '../client';

export const explainScript = (script) =>
  client.post('/templates/explain', { script });

export const analyzeScript = (script) =>
  client.post('/templates/analyze', { script });

export const auditScript = (script) =>
  client.post('/templates/audit', { script });

export const assistantHelp = (id) =>
  client.get(`/templates/${id}/assistant-help`);

export const explainVariables = (template) =>
  client.post('/templates/variables/explain', { template });

export const summarizeLogs = (logs) =>
  client.post('/templates/logs/summarize', { logs });

export const bundleSuggestion = (needs) =>
  client.post('/templates/bundle', { needs });

export const simulateScript = (script) =>
  client.post('/templates/simulate', { script });

// AI cache CRUD
export const listCache = () => client.get('/ai-cache');

export const createCache = (data) => client.post('/ai-cache', data);

export const getCache = (id) => client.get(`/ai-cache/${id}`);

export const updateCache = (id, data) => client.put(`/ai-cache/${id}`, data);

export const deleteCache = (id) => client.delete(`/ai-cache/${id}`);
