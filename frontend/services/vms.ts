// services/terminal.ts
import { api } from './api';

export interface TerminalVM {
  id: string;
  name: string;
  status: string;
  ip: string | null;
  instance_id: string | null;
  node: string;
  type: string; // 'qemu'
  ip_source: 'db' | 'agent' | null;
  ping_ok: boolean | null;
  tags?: string[];
}

export async function fetchTerminalVMs(onlyConnectable = false): Promise<TerminalVM[]> {
  const res = await api.get('/terminal/vms', { params: { onlyConnectable } });
  return res.data;
}

// services/vms.ts
export async function testSshConnection(params: {
  vm_id: string;
  ip: string;
  ssh_user: string;
}) {
  try {
    const res = await api.post('/terminal/ssh/test', params);
    return res.data as { ok: boolean; message?: string };
  } catch (e: any) {
    const msg = e?.response?.data?.message || e?.message || 'Erreur inconnue';
    // propage une erreur claire
    throw new Error(`[POST /terminal/ssh/test] ${msg}`);
  }
}

export async function execSshCommand(params: {
  vm_id: string;
  ip: string;
  ssh_user: string;
  command: string;
}) {
  try {
    const res = await api.post('/terminal/ssh/exec', params);
    return res.data as { stdout: string; stderr?: string; code?: number };
  } catch (e: any) {
    const msg = e?.response?.data?.message || e?.message || 'Erreur inconnue';
    throw new Error(`[POST /terminal/ssh/exec] ${msg}`);
  }
}

// --- Proxmox VM management ---

export interface ProxmoxVM {
  vmid: number;
  name: string;
  status: string;
  node: string;
  template?: number;
  uptime?: number;
  [key: string]: any;
}

export interface ProxmoxVMList {
  vms: ProxmoxVM[];
  templates: ProxmoxVM[];
}

export interface VmDeletionPayload {
  vm_id: number;
  instance_id: string;
}

export async function listProxmoxVMs(): Promise<ProxmoxVMList> {
  const res = await api.get('/vms');
  return res.data as ProxmoxVMList;
}

export interface ProxmoxStorage {
  storage: string;
  content: string;
  maxdisk: number;
  disk: number;
  plugintype: string;
}

export interface ProxmoxNode {
  node: string;
  status: string;
}

export interface NodeSystemInfo {
  node: string;
  memory: { total: number; used: number; free: number };
  cpu: { cores: number; sockets: number };
  disk: { total: number; used: number; free: number };
}

export async function listProxmoxStorages(): Promise<ProxmoxStorage[]> {
  const res = await api.get('/vms/storages');
  return res.data as ProxmoxStorage[];
}

export async function listProxmoxStoragesByNode(node: string): Promise<ProxmoxStorage[]> {
  const res = await api.get('/vms/storages', { params: { node } });
  return res.data as ProxmoxStorage[];
}

export async function listProxmoxNodes(): Promise<ProxmoxNode[]> {
  const res = await api.get('/vms/nodes');
  return res.data as ProxmoxNode[];
}

export async function getNodeSystemInfo(node?: string): Promise<NodeSystemInfo> {
  const res = await api.get('/vms/system', { params: { node } });
  return res.data as NodeSystemInfo;
}

export async function listProxmoxTemplates(): Promise<ProxmoxVM[]> {
  const res = await listProxmoxVMs();
  return res.templates;
}

export async function startProxmoxVM(vmId: number) {
  const res = await api.post(`/vms/${vmId}/start`);
  return res.data;
}

export async function stopProxmoxVM(vmId: number) {
  const res = await api.post(`/vms/${vmId}/stop`);
  return res.data;
}

export async function deleteProxmoxVM(payload: VmDeletionPayload) {
  const res = await api.post('/vms/delete', payload);
  return res.data;
}

export async function checkProxmoxVMStatus(params: {
  vm_id: number;
  ip_address: string;
}) {
  const res = await api.post('/vms/check-status', params);
  return res.data as { vm_status: string; ping_ok: boolean; status_summary: string };
}

export async function convertProxmoxVM(params: { vm_id: number }) {
  const res = await api.post('/vms/convert', params);
  return res.data;
}

export interface VmConversionRecord {
  id: number;
  vm_name: string;
  vm_id: number;
  user_id: number;
  created_at: string;
  updated_at: string;
}

export async function listVmConversions(): Promise<VmConversionRecord[]> {
  const res = await api.get('/vms/conversions');
  return res.data;
}
