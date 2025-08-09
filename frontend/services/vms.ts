import { api } from './api';

export interface TerminalVM {
  id: string;
  name: string;
  status: string;
  ip: string | null;
}

export async function fetchTerminalVMs(): Promise<TerminalVM[]> {
  const res = await api.get('/terminal/vms');
  return res.data;
}
