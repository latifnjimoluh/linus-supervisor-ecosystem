import { api } from './api';

export interface MonitoringSummary {
  total: number;
  running: number;
  stopped: number;
  error: number;
}

export interface MonitoringOverview {
  summary: MonitoringSummary;
  vms: Array<{
    id: string;
    name: string;
    ip: string;
    status: 'running' | 'stopped' | 'error';
    os: string;
    cpu_usage: number;
    memory_usage: number;
    memory_total: number;
    disk_usage: number;
    uptime: string;
    services_count: number;
    active_services: number;
    last_monitoring: string | null;
  }>;
}

export async function fetchMonitoringOverview(): Promise<MonitoringOverview> {
  const res = await api.get('/monitoring/overview');
  return res.data;
}

export interface VmDetailResponse {
  id: string;
  name: string;
  ip: string | null;
  proxmox: any;
  status: any;
  monitoring: any;
}

export async function fetchVmDetails(id: string): Promise<VmDetailResponse> {
  const res = await api.get(`/monitoring/vm/${id}`);
  return res.data;
}
