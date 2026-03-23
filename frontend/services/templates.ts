import { api } from "./api";

export interface FieldSchemaField {
  name: string;
  label: string;
  type: "text" | "number" | "boolean" | "select";
  required?: boolean;
  default?: string | number | boolean;
}

export interface FieldSchema {
  fields: FieldSchemaField[];
}

export interface Template {
  id: number;
  name: string;
  service_type: string;
  category: string;
  description?: string;
  template_content: string;
  script_path?: string;
  fields_schema?: FieldSchema;
  status?: string;
}

export const listTemplates = async (): Promise<Template[]> => {
  const res = await api.get("/templates");
  return res.data.data?.templates ?? res.data.templates ?? [];
};

export const createTemplate = async (
  payload: Omit<Template, "id">
): Promise<Template> => {
  const res = await api.post("/templates", payload);
  return res.data;
};

export const getTemplate = async (id: number): Promise<Template> => {
  const res = await api.get(`/templates/${id}`);
  return res.data;
};

export const updateTemplate = async (
  id: number,
  payload: Partial<Omit<Template, "id">>
): Promise<Template> => {
  const res = await api.put(`/templates/${id}`, payload);
  return res.data.template ?? res.data;
};

export const deleteTemplate = async (
  id: number
): Promise<{ message: string }> => {
  const res = await api.delete(`/templates/${id}`);
  return res.data;
};

export const restoreTemplate = async (
  id: number
): Promise<{ message: string }> => {
  const res = await api.post(`/templates/${id}/restore`);
  return res.data;
};

export const generateScript = async (
  template_id: number,
  config_data: Record<string, string | number>
): Promise<{ script: string; fileName: string; contentType: string; id: number }> => {
  const res = await api.post("/templates/generate", {
    template_id,
    config_data,
  });
  return res.data;
};

export const simulateScript = async (
  script: string
): Promise<{ simulation: string }> => {
  const res = await api.post("/templates/simulate", { script });
  return res.data;
};

export const analyzeTemplate = async (
  script: string,
  id?: number
): Promise<{ analysis: string }> => {
  const res = await api.post("/templates/analyze", {
    script,
    entity_type: 'template',
    entity_id: id,
  });
  return res.data;
};
