import { api } from './api';

export interface Alert {
  id: number;
  server: string;
  service: string;
  severity: string;
  status: string;
  description: string;
  created_at: string;
}

export async function listAlerts(params?: { page?: number; limit?: number }) {
  const res = await api.get('/alerts', { params });
  return res.data as { data: Alert[]; pagination: { page: number; pages: number; total: number; limit: number } };
}

export async function getAlert(id: number | string) {
  const res = await api.get(`/alerts/${id}`);
  return res.data as Alert;
}

export async function ackAlert(id: number | string) {
  const res = await api.post(`/alerts/${id}/ack`);
  return res.data as { message: string; alert: Alert };
}
