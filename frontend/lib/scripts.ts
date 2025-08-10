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
  const res = await api.get("/scripts")
  const data = res.data.data || res.data
  return (data || []).map((s: any) => ({ ...s, type: "script" }))
}
