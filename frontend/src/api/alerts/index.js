import client from '../client';

export const listAlerts = (params) => client.get('/alerts', { params });
export const updateAlert = (id, data) => client.patch(`/alerts/${id}`, data);
