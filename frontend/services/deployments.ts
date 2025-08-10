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
