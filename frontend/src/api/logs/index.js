import client from '../client';

export const getLogs = (params) => client.get('/logs', { params });
