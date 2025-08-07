import client from '../client';

export const login = (email, password, remember) =>
  client.post('/auth/login', { email, password, remember });

export const register = (data) => client.post('/auth/register', data);

export const requestReset = (email) =>
  client.post('/auth/request-reset', { email });

export const resetPassword = (code, password) =>
  client.post('/auth/reset-password', { code, password });

export const resetHistory = () => client.get('/auth/reset-history');

export const me = () => client.get('/auth/me');

export const changePassword = (currentPassword, newPassword) =>
  client.post('/auth/change-password', { currentPassword, newPassword });
