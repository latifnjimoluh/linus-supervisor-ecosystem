import { api } from './api';

export interface DeploymentDetail {
  id: number;
  vm_name: string;
  template: string;
  status: string;
  started_at: string;
  ended_at?: string;
  log: string | null;
}

export async function fetchDeployment(id: string): Promise<DeploymentDetail> {
  const res = await api.get(`/deployments/${id}`);
  return res.data;
}

export async function summarizeDeploymentLogs(id: string): Promise<{ summary: string }> {
  const res = await api.get(`/deployments/${id}/summary`);
  return res.data;
}

export interface HistoryFilters {
  page?: number;
  limit?: number;
  status?: string;
  user?: string;
  startDate?: string;
  endDate?: string;
}

export async function fetchDeploymentHistory(filters: HistoryFilters = {}) {
  const params = new URLSearchParams();
  Object.entries(filters).forEach(([k, v]) => {
    if (v !== undefined && v !== "") params.append(k, String(v));
  });
  const query = params.toString();
  const res = await api.get(`/deployments/history${query ? `?${query}` : ""}`);
  return res.data;
}

export async function analyzeDeploymentConfig(config: any): Promise<{ analysis: string }> {
  const res = await api.post('/deployments/analyze', config);
  return res.data;
}

export async function checkDeploymentSpace(diskSize: number): Promise<{
  available: number;
  requested: number;
  fits: boolean;
  suggested: number;
}> {
  const res = await api.get('/deployments/check-space', { params: { disk_size: diskSize } });
  return res.data;
}
