import { fetchTemplatesAndScripts } from "./templates"

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
