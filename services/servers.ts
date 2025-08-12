import { api } from './api'

export interface InfrastructureServer {
  id: string
  name: string
  ip: string
  zone: string
  tags?: string[]
  services?: string[]
  supervised?: boolean
  status?: string
}

export async function listServers(): Promise<InfrastructureServer[]> {
  const res = await api.get('/dashboard/servers')
  return res.data
}

export async function createServer(payload: { name: string; ip: string; zone: string }): Promise<InfrastructureServer> {
  const res = await api.post('/dashboard/servers', payload)
  return res.data
}

export async function deleteServer(id: string): Promise<void> {
  await api.delete(`/dashboard/servers/${id}`)
}
