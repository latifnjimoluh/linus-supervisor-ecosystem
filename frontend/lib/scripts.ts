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
  const res = await api.get("/scripts/generated")
  const data = res.data
  if (!Array.isArray(data)) return []
  return data.flatMap((group: any) =>
    (group.scripts || []).map((s: any) => ({
      id: s.id,
      name: s.service_type || s.script_path,
      category: s.category || group.category,
      description: s.description,
      script_path: s.script_path,
      type: "script",
      template_content: s.template_content || "",
    }))
  )
}
