import client from '../client';

export const deploy = (data) => client.post('/terraform/deploy', data);
