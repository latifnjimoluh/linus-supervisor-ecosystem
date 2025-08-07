import client from './client';

export const getSettings = () => client.get('/settings/notifications');
export const updateSettings = (data) => client.put('/settings/notifications', data);
export const testNotification = () => client.post('/settings/notifications/test');
