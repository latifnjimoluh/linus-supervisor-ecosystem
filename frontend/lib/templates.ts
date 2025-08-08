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

export type Template = {
  id: number
  name: string
  service_type?: string
  category: string
  description: string
  type: "template" | "script"
  template_content: string
  script_path?: string
  fields_schema?: FieldSchema
}

const BASE = "/api/templates"

export async function listTemplates(): Promise<Template[]> {
  const res = await fetch(BASE, { cache: "no-store" })
  if (!res.ok) throw new Error("Failed to list templates")
  return res.json()
}

export async function createTemplate(payload: Omit<Template, "id">): Promise<Template> {
  const res = await fetch(BASE, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(payload),
  })
  if (!res.ok) throw new Error("Failed to create template")
  return res.json()
}

export async function getTemplate(id: number): Promise<Template> {
  const res = await fetch(`${BASE}/${id}`, { cache: "no-store" })
  if (!res.ok) throw new Error("Template not found")
  return res.json()
}

export async function updateTemplate(id: number, payload: Partial<Omit<Template, "id">>): Promise<Template> {
  const res = await fetch(`${BASE}/${id}`, {
    method: "PUT",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(payload),
  })
  if (!res.ok) throw new Error("Failed to update template")
  return res.json()
}

export async function deleteTemplate(id: number): Promise<{ success: boolean }> {
  const res = await fetch(`${BASE}/${id}`, { method: "DELETE" })
  if (!res.ok) throw new Error("Failed to delete template")
  return res.json()
}

export async function generateScript(template_id: number, config_data: Record<string, string | number>) {
  const res = await fetch(`${BASE}/generate`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ template_id, config_data }),
  })
  if (!res.ok) throw new Error("Failed to generate script")
  return res.json() as Promise<{ script: string; template_id: number }>
}
