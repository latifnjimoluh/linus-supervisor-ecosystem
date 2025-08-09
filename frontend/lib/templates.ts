export type FieldSchemaField = {
  name: string
  label: string
  type: "text" | "number" | "boolean" | "select"
  required?: boolean
  default?: string | number | boolean
}

export type FieldSchema = {
  fields: FieldSchemaField[]
}

import { api } from "@/services/api"

export type Template = {
  id: number
  name: string
  service_type: string
  category: string
  description?: string
  template_content: string
  script_path?: string
  fields_schema?: FieldSchema
  type?: "template" | "script"
}

export async function listTemplates(): Promise<Template[]> {
  const res = await api.get("/templates")
  return (res.data.data || []).map((t: any) => ({ ...t, type: "template" }))
}

export async function createTemplate(
  payload: Omit<Template, "id" | "type">
): Promise<Template> {
  const res = await api.post("/templates", payload)
  return { ...res.data, type: "template" }
}

export async function getTemplate(id: number): Promise<Template> {
  const res = await api.get(`/templates/${id}`)
  return { ...res.data, type: "template" }
}

export async function updateTemplate(
  id: number,
  payload: Partial<Omit<Template, "id" | "type">>
): Promise<Template> {
  const res = await api.put(`/templates/${id}`, payload)
  const tpl = res.data.template || res.data
  return { ...tpl, type: "template" }
}

export async function deleteTemplate(id: number): Promise<{ message: string }> {
  const res = await api.delete(`/templates/${id}`)
  return res.data
}

export async function generateScript(
  template_id: number,
  config_data: Record<string, string | number>
) {
  const res = await api.post(`/templates/generate`, { template_id, config_data })
  return res.data as { script: string; fileName: string; contentType: string }
}

export async function simulateScript(script: string) {
  const res = await api.post(`/templates/simulate`, { script })
  return res.data as { simulation: string }
}
