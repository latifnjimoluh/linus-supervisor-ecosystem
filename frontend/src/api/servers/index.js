import client from '../client';

export const list = () => client.get('/servers');
export const get = (id) => client.get(`/servers/${id}`);
export const create = (data) => client.post('/servers', data);
export const update = (id, data) => client.put(`/servers/${id}`, data);
export const remove = (id, params) => client.delete(`/servers/${id}`, { params });
