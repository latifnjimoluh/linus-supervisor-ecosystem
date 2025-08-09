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

export const getGeneratedScripts = async (): Promise<ScriptGroup[]> => {
  const res = await api.get("/scripts/generated");
  return res.data;
};

export const getServiceTypes = async (): Promise<string[]> => {
  const res = await api.get("/scripts/service-types");
  return res.data;
};
