
import { api } from "@/services/api"

// ---- Types ----
export interface Script {
  id: number
  name: string
  category: string
  service_type: string
  description?: string
  status?: "actif" | "supprime"
  type: "script"
}

export interface ScriptDetail extends Script {
  content: string | null
}

// ---- Read ----
export const getGeneratedScriptById = async (id: number): Promise<ScriptDetail> => {
  // correspond à GET /scripts/generated/:id (retourne { ...script, content })
  const res = await api.get(`/scripts/generated/${id}`)
  return res.data
}

export const getScriptContent = async (id: number): Promise<string> => {
  const detail = await getGeneratedScriptById(id)
  return detail.content ?? ""
}

// ---- Update (PUT /scripts/:id) ----
// côté backend, on a ajouté un controller de modification dédié aux scripts
// qui accepte { name?, content? }.
export const updateScript = async (
  id: number,
  payload: { name?: string; content?: string }
): Promise<ScriptDetail> => {
  const res = await api.put(`/scripts/${id}`, payload)
  return res.data
}

// ---- Delete / Restore ----
export const deleteScript = async (id: number): Promise<{ message: string }> => {
  const res = await api.delete(`/scripts/${id}`)
  return res.data
}

export const restoreScript = async (id: number): Promise<{ message: string }> => {
  const res = await api.post(`/scripts/${id}/restore`)
  return res.data
}

// ---- Analyze (POST /scripts/:id/analyze) ----
export const analyzeScript = async (script: string, id: number) => {
  const res = await api.post(`/scripts/${id}/analyze`, {
    script,
    entity_type: "script",
    entity_id: id,
  })
  return res.data // { analysis: string }
}
