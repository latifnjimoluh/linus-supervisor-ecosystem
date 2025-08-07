import client from '../client';

export const getMySettings = () => client.get('/settings/me');

export const createMySettings = (data) => client.post('/settings/me', data);

export const updateMySettings = (data) => client.put('/settings/me', data);

export const listSettings = (params) => client.get('/settings', { params });
