// services/logs.ts
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
  const len = (res.headers && (res.headers['content-length'] || res.headers['Content-Length'])) as string | undefined;
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

// 🔹 NEW: téléchargement d’un log par ID
export async function downloadLog(id: number): Promise<{ blob: Blob; filename?: string }> {
  const res = await api.get(`/logs/${id}/download`, { responseType: 'blob' })

  // Essayer d’extraire un nom de fichier depuis Content-Disposition si présent
  const dispo: string | undefined = (res.headers['content-disposition'] || res.headers['Content-Disposition']) as any
  let filename: string | undefined
  if (dispo) {
    const match = /filename\*?=(?:UTF-8'')?["']?([^"';\n]+)["']?/i.exec(dispo)
    if (match && match[1]) filename = decodeURIComponent(match[1])
  }

  return { blob: res.data as Blob, filename }
}

// 🔹 NEW: lire le contenu (texte) d’un log de déploiement
export async function viewDeploymentLogText(id: number): Promise<string> {
  const res = await api.get(`/logs/deployments/${id}/view`, {
    responseType: 'text',
    transformResponse: (r) => r, // ne pas JSON.parse
  })
  // Axios peut déjà te renvoyer du texte selon la config; on force le type
  return typeof res.data === 'string' ? res.data : String(res.data)
}

// 🔹 NEW: télécharger un log de déploiement
export async function downloadDeploymentLog(id: number): Promise<{ blob: Blob; filename?: string }> {
  const res = await api.get(`/logs/deployments/${id}/download`, { responseType: 'blob' })

  const dispo: string | undefined = (res.headers['content-disposition'] || res.headers['Content-Disposition']) as any
  let filename: string | undefined
  if (dispo) {
    const match = /filename\*?=(?:UTF-8'')?["']?([^"';\n]+)["']?/i.exec(dispo)
    if (match && match[1]) filename = decodeURIComponent(match[1])
  }
  return { blob: res.data as Blob, filename }
}
