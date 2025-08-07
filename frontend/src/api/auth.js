import client from './client';

export const login = (email, password) =>
  client.post('/auth/login', { email, password });

export const register = (data) => client.post('/auth/register', data);

export const requestReset = (email) =>
  client.post('/auth/request-reset', { email });

export const resetPassword = (code, password) =>
  client.post('/auth/reset-password', { code, password });

export const resetHistory = () => client.get('/auth/reset-history');
