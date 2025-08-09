import { api } from './api';

export interface LogEntry {
  id: number;
  action: string;
  type: string;
  timestamp: string;
  user: string | null;
  entity: string | null;
  status: 'success' | 'error' | 'warning' | 'info';
  description: string;
  details: string;
  ip_address: string | null;
  vm_id: string | null;
}

export async function listLogs(params?: { q?: string; page?: number; pageSize?: number }) {
  const res = await api.get('/logs', { params });
  return res.data as { results: LogEntry[]; total: number; page?: number; pageSize?: number; paginationDisabled?: boolean };
}
