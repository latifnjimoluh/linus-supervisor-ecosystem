import { api } from './api';

export interface DeploymentDetail {
  id: number;
  instance_id?: string;
  vm_name: string;
  template: string;
  status: string;
  started_at: string;
  ended_at?: string;
  log: string | null;
}

export interface LastDeployment extends DeploymentDetail {
  instance_id: string;
}

export async function fetchDeployment(id: string): Promise<DeploymentDetail> {
  const res = await api.get(`/deployments/${id}`);
  return res.data;
}

export async function fetchLastDeployment(): Promise<LastDeployment> {
  const res = await api.get('/deployments/last');
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
  template?: string;
}

export interface DeleteRecord {
  id: number;
  vm_name: string;
  vm_ip?: string;
  instance_id?: string;
  deleted_at: string;
  user_email?: string;
  log_path?: string;
}

export interface HistoryResponse {
  deployments: {
    id: number;
    instance_id?: string;
    vm_name: string;
    template: string;
    started_at: string;
    duration: string;
    status: string;
    user_email: string;
    log_path?: string;
  }[];
  deletes: DeleteRecord[];
  pagination: {
    page: number;
    limit: number;
    deploymentsTotal: number;
    deletionsTotal: number;
  };
}

export async function fetchDeploymentHistory(
  filters: HistoryFilters = {}
): Promise<HistoryResponse> {
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

export interface CapacityInfo {
  disk: { available: number; requested: number; fits: boolean; suggested: number };
  memory: { available: number; requested: number; fits: boolean; suggested: number };
  cpu: { available: number; requested: number; fits: boolean; suggested: number };
}

export async function checkDeploymentCapacity(
  diskSize: number,
  memoryMb: number,
  cores: number
): Promise<CapacityInfo> {
  const res = await api.get('/deployments/check-capacity', {
    params: { disk_size: diskSize, memory_mb: memoryMb, cores },
  });
  return res.data;
}
