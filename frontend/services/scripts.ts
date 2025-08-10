import { api } from "./api";

export interface GeneratedScript {
  id: number;
  category: string;
  service_type: string;
  script_path: string;
  description?: string;
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
