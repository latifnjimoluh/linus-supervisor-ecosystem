import { api } from './api';

export interface MonitoringSummary {
  total: number;
  running: number;
  stopped: number;
  error: number;
}

export interface MonitoringVm {
  id: string;
  name: string;
  ip: string;
  status: 'running' | 'stopped' | 'error';
  hostname: string;
  cpu_usage: number;
  memory_usage: number;
  memory_total: number;
  disk_usage: number;
  uptime: string;
  services_count: number;
  active_services: number;
  last_monitoring: string | null;
  template?: string;
  created_at?: string | null;
  instance_id?: string | null;
  alerts?: Array<{
      id: number;
      type: 'CPU' | 'RAM';
      value_percent: number;
      threshold: number;
      state: string;
      freshness: 'fresh' | 'stale';
      description: string;
    }>;
}

export interface MonitoringOverview {
  summary: MonitoringSummary;
  vms: MonitoringVm[];
  templates: MonitoringVm[];
}

export async function fetchMonitoringOverview(): Promise<MonitoringOverview> {
  const res = await api.get('/monitoring');
  return res.data;
}

export interface VmDetailResponse {
  id: string;
  name: string;
  ip: string | null;
  ping_ok: boolean | null;
  cpu_usage: number;
  memory_usage: number; // in KB
  memory_total: number; // in KB
  disk_usage: number; // used KB
  disk_total: number; // total KB
  network_in: number; // KB/s
  network_out: number; // KB/s
  load_average: number;
  template: string;
  created_at: string | null;
  instance_id: string | null;
  proxmox: any;
  status: any;
  monitoring: any;
}

export async function fetchVmDetails(id: string): Promise<VmDetailResponse> {
  const res = await api.get(`/monitoring/${id}`);
  return res.data;
}

export async function collectMonitoringData(vm_ip: string, username: string) {
  const res = await api.post('/monitoring/collect', { vm_ip, username });
  return res.data;
}

export interface MonitoringRecord {
  id: number;
  vm_ip: string;
  ip_address: string;
  instance_id: string;
  services_status: any;
  system_status: any;
  retrieved_at: string;
}

export async function fetchVmHistory(id: string): Promise<MonitoringRecord[]> {
  const res = await api.get(`/monitoring/${id}/history`);
  return res.data;
}
