import client from './client';

export const listVms = (params) => client.get('/vms', { params });

export const startVm = (vmId) => client.post(`/vms/${vmId}/start`);

export const stopVm = (vmId) => client.post(`/vms/${vmId}/stop`);

export const deleteVm = (data) => client.post('/vms/delete', data);

export const checkStatus = (data) => client.post('/vms/check-status', data);

export const convertVm = (data) => client.post('/vms/convert', data);

export const listConversions = () => client.get('/vms/conversions');
