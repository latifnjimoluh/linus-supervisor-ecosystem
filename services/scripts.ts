import { api } from "./api";

export interface GeneratedScript {
  id: number;
  category: string;
  service_type: string;
  script_path: string;
  description?: string;
  status?: string;
}

export interface ScriptGroup {
  category: string;
  scripts: GeneratedScript[];
}

export interface GeneratedScriptDetail extends GeneratedScript {
  content: string | null;
}

export const getGeneratedScripts = async (): Promise<ScriptGroup[]> => {
  const res = await api.get("/scripts/generated");
  return res.data;
};

export const getServiceTypes = async (): Promise<string[]> => {
  const res = await api.get("/scripts/service-types");
  return res.data;
};

export const getGeneratedScriptById = async (id: number): Promise<GeneratedScriptDetail> => {
  const res = await api.get(`/scripts/generated/${id}`);
  return res.data;
};

export const deleteScript = async (
  id: number
): Promise<{ message: string }> => {
  const res = await api.delete(`/scripts/${id}`);
  return res.data;
};

export const restoreScript = async (
  id: number
): Promise<{ message: string }> => {
  const res = await api.post(`/scripts/${id}/restore`);
  return res.data;
};

// Nouvelle fonction pour mise à jour du script
export const updateScript = async (
  id: number,
  data: Partial<GeneratedScriptDetail> // permet d’envoyer category, service_type, description, status, content...
): Promise<{ message: string; script: GeneratedScriptDetail }> => {
  const res = await api.put(`/scripts/${id}`, data);
  return res.data;
};

// services/scripts.ts (ou l’endroit où tu déclenches l’analyse)
export const analyzeScript = async (script: string, id: number) => {
  const res = await api.post(`/scripts/${id}/analyze`, {
    script,
    entity_type: 'script',
    entity_id: id,
  });
  return res.data; // { analysis: string }
};
