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
  host?: string | null;
  level?: string | null;
  source?: string | null;
  ip_address: string | null;
  vm_id: string | null;
}

export interface DeploymentLog {
  id: number;
  instance_id: string | null;
  vm_name: string | null;
  status: string;
  started_at: string | null;
  ended_at: string | null;
  user: string | null;
}

export async function listLogs(params?: {
  search?: string;
  sort?: string;
  order?: string;
  page?: number;
  limit?: number;
  from?: string;
  to?: string;
}) {
  const res = await api.get('/logs', { params });
  return res.data as {
    items: LogEntry[];
    total_after_filter: number;
    page?: number;
    limit?: number;
  };
}

export async function exportLogs(params?: {
  search?: string;
  sort?: string;
  order?: string;
  from?: string;
  to?: string;
  type?: string;
  status?: string;
}) {
  const res = await api.get('/logs/export', {
    params,
    responseType: 'blob',
  });
  return res.data as Blob;
}

export async function estimateLogsExportSize(params?: {
  search?: string;
  sort?: string;
  order?: string;
  from?: string;
  to?: string;
  type?: string;
  status?: string;
}) {
  const res = await api.head('/logs/export', { params });
  const len = res.headers['content-length'];
  return len ? Number(len) : null;
}

export async function listDeploymentLogs(params?: {
  search?: string;
  sort?: string;
  order?: string;
  page?: number;
  limit?: number;
}) {
  const res = await api.get('/logs/deployments', { params });
  return res.data as {
    items: DeploymentLog[];
    total_after_filter: number;
    page?: number;
    limit?: number;
  };
}
