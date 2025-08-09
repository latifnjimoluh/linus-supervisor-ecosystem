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
