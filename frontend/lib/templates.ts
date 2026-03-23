import { api } from "@/services/api"
import type { Script } from "./scripts"
import {
  listTemplates as listTemplatesService,
  createTemplate as createTemplateService,
  getTemplate as getTemplateService,
  updateTemplate as updateTemplateService,
  deleteTemplate as deleteTemplateService,
  restoreTemplate as restoreTemplateService,
  analyzeTemplate as analyzeTemplateService,
  generateScript as generateScriptService,
  simulateScript as simulateScriptService,
  type Template,
  type FieldSchema,
  type FieldSchemaField,
} from "@/services/templates"

export type { Template, FieldSchema, FieldSchemaField }

export async function fetchTemplatesAndScripts(status: string = 'actif'): Promise<{
  templates: Template[]
  scripts: Script[]
}> {
  const res = await api.get("/templates", { params: { status } })
  const data = res.data.data || {}
  const templates = Array.isArray(data.templates)
    ? data.templates.map((t: any) => ({ ...t, type: "template", status: t.status }))
    : []
  const scripts = Array.isArray(data.scripts)
    ? data.scripts.map((s: any) => ({
        id: s.id,
        name: s.service_type || s.script_path,
        category: s.category || "",
        description: s.description,
        script_path: s.script_path,
        template_content: s.template_content || "",
        status: s.status,
        type: "script",
      }))
    : []
  return { templates, scripts }
}

export const listTemplates = listTemplatesService
export const createTemplate = createTemplateService
export const getTemplate = getTemplateService
export const updateTemplate = updateTemplateService
export const deleteTemplate = deleteTemplateService
export const restoreTemplate = restoreTemplateService
export const analyzeTemplate = analyzeTemplateService
export const generateScript = generateScriptService
export const simulateScript = simulateScriptService
