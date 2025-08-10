import { fetchTemplatesAndScripts } from "./templates"
import { api } from "@/services/api"
export type Script = {
  id: number
  name: string
  category: string
  description?: string
  template_content: string
  script_path?: string
  type?: "script"
}

export async function listScripts(): Promise<Script[]> {
  const { scripts } = await fetchTemplatesAndScripts()
  return scripts
}
export async function deleteScript(id: number): Promise<{ message: string }> {
  const res = await api.delete(`/scripts/${id}`)
  return res.data
}