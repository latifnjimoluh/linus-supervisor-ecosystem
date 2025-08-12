import { fetchTemplatesAndScripts } from "./templates"
import {
  deleteScript as deleteScriptService,
  restoreScript as restoreScriptService,
  analyzeScript as analyzeScriptService,
} from "@/services/scripts"
import { api } from "@/services/api"

export type Script = {
  id: number
  name: string
  category: string
  description?: string
  template_content: string
  script_path?: string
  status?: string
  type?: "script"
}

export async function listScripts(status: string = 'actif'): Promise<Script[]> {
  const { scripts } = await fetchTemplatesAndScripts(status)
  return scripts
}

export const deleteScript = deleteScriptService
export const restoreScript = restoreScriptService
export const analyzeScript = analyzeScriptService

export async function getScriptContent(id: number): Promise<string> {
  const res = await api.get(`/scripts/${id}`)
  return res.data?.content || ""
}
