import client from './client';

export const listPermissions = (params = {}) =>
  client.get('/permissions', { params });

export const getPermission = (id) => client.get(`/permissions/${id}`);

export const createPermission = (data) => client.post('/permissions', data);

export const updatePermission = (id, data) =>
  client.put(`/permissions/${id}`, data);

export const deletePermission = (id) => client.delete(`/permissions/${id}`);

export const assignPermissions = (payload) =>
  client.post('/permissions/assign', payload);

export const unassignPermissions = (payload) =>
  client.post('/permissions/unassign', payload);

export const rolePermissions = (roleId) =>
  client.get(`/permissions/role/${roleId}`);
