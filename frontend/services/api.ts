import axios from "axios"

const apiUrl = process.env.NEXT_PUBLIC_API_URL || "http://localhost:3000"
console.log("URL de la requête :", apiUrl);
export const api = axios.create({
  baseURL: apiUrl,
})

export const getAuthToken = (): string | null => {
  if (typeof window !== "undefined") {
    return localStorage.getItem("auth_token")
  }
  return null
}

export const setAuthToken = (token: string): void => {
  if (typeof window !== "undefined") {
    localStorage.setItem("auth_token", token)
  }
}

export const removeAuthToken = (): void => {
  if (typeof window !== "undefined") {
    localStorage.removeItem("auth_token")
  }
}

api.interceptors.request.use(
  (config) => {
    const token = getAuthToken()
    if (token) {
      config.headers = config.headers || {}
      config.headers.Authorization = `Bearer ${token}`
    }
    return config
  },
  (error) => Promise.reject(error),
)

api.interceptors.response.use(
  (response) => response,
  (error) => {
    console.error("Erreur API:", error.message || "Erreur inconnue")
    return Promise.reject(error)
  },
)

// ==================== AUTH ====================

export const login = async (email: string, password: string, remember?: boolean) => {
  const res = await api.post("/auth/login", { email, password, remember })
  if (res.data?.token) setAuthToken(res.data.token)
  return res.data
}

export const register = async (data: {
  first_name: string
  last_name: string
  email: string
  password: string
  role_id: number
}) => {
  const res = await api.post("/auth/register", data)
  return res.data
}

export const requestResetCode = async (email: string) => {
  const res = await api.post("/auth/request-reset", { email })
  return res.data
}

export const resetPassword = async (code: string, password: string) => {
  const res = await api.post("/auth/reset-password", { code, password })
  return res.data
}

export const getResetHistory = async () => {
  const res = await api.get("/auth/reset-history")
  return res.data
}

// ==================== USERS ====================

export const getUsers = async () => {
  const res = await api.get("/users")
  return res.data
}

export const getUser = async (id: number) => {
  const res = await api.get(`/users/${id}`)
  return res.data
}

export const createUser = async (data: {
  first_name: string
  last_name: string
  email: string
  password: string
  role_id: number
}) => {
  const res = await api.post("/users", data)
  return res.data
}

export const updateUser = async (id: number, data: any) => {
  const res = await api.put(`/users/${id}`, data)
  return res.data
}

export const patchUser = async (id: number, data: any) => {
  const res = await api.patch(`/users/${id}`, data)
  return res.data
}

export const deleteUser = async (id: number) => {
  const res = await api.delete(`/users/${id}`)
  return res.data
}

export const searchUsers = async (query: string) => {
  const res = await api.get("/users/search", { params: { query } })
  return res.data
}

// ==================== ROLES ====================

export const getRoles = async () => {
  const res = await api.get("/roles")
  return res.data
}

export const getRole = async (id: number) => {
  const res = await api.get(`/roles/${id}`)
  return res.data
}

export const createRole = async (data: { name: string; description?: string }) => {
  const res = await api.post("/roles", data)
  return res.data
}

export const updateRole = async (id: number, data: any) => {
  const res = await api.put(`/roles/${id}`, data)
  return res.data
}

export const deleteRole = async (id: number) => {
  const res = await api.delete(`/roles/${id}`)
  return res.data
}

// ==================== PERMISSIONS ====================

export const getPermissions = async (params?: { page?: number }) => {
  const res = await api.get("/permissions", { params })
  return res.data
}

export const createPermission = async (data: { name: string; description?: string }) => {
  const res = await api.post("/permissions", data)
  return res.data
}

export const assignPermissions = async (data: { role_id: number; permission_ids: number[] }[]) => {
  const res = await api.post("/permissions/assign", data)
  return res.data
}

export const unassignPermissions = async (data: { role_id: number; permission_ids: number[] }[]) => {
  const res = await api.post("/permissions/unassign", data)
  return res.data
}

export const getPermissionsByRole = async (roleId: number) => {
  const res = await api.get(`/permissions/role/${roleId}`)
  return res.data
}

export const getPermission = async (id: number) => {
  const res = await api.get(`/permissions/${id}`)
  return res.data
}

export const updatePermission = async (id: number, data: any) => {
  const res = await api.put(`/permissions/${id}`, data)
  return res.data
}

export const deletePermission = async (id: number) => {
  const res = await api.delete(`/permissions/${id}`)
  return res.data
}

// ==================== LOGS ====================

export interface LogEntry {
  id: number
  action: string
  details?: string
  user?: { email?: string }
  created_at: string
}

export const getLogs = async (params?: { page?: number }) => {
  const res = await api.get("/logs", { params })
  return res.data
}

// ==================== SERVERS ====================

export interface ServerEntry {
  id: number
  ip: string
  name: string
  zone: string
}

export const getServers = async () => {
  const res = await api.get("/servers")
  return res.data
}

export const getServer = async (id: number) => {
  const res = await api.get(`/servers/${id}`)
  return res.data
}

export const createServer = async (data: { ip: string; name: string; zone: string }) => {
  const res = await api.post("/servers", data)
  return res.data
}

export const updateServer = async (
  id: number,
  data: { ip?: string; name?: string; zone?: string }
) => {
  const res = await api.put(`/servers/${id}`, data)
  return res.data
}

export const deleteServer = async (id: number) => {
  const res = await api.delete(`/servers/${id}`)
  return res.data
}

// ==================== SETTINGS ====================

export interface UserSettings {
  cloudinit_user: string
  cloudinit_password: string
  proxmox_api_url: string
  proxmox_api_token_id: string
  proxmox_api_token_name: string
  proxmox_api_token_secret: string
  pm_user: string
  pm_password: string
  proxmox_node: string
  vm_storage: string
  vm_bridge: string
  ssh_public_key_path: string
  ssh_private_key_path: string
  statuspath: string
  servicespath: string
  instanceinfopath: string
  proxmox_host: string
  proxmox_ssh_user: string
}

export const getMySettings = async (): Promise<UserSettings | null> => {
  try {
    const res = await api.get("/settings/me")
    return res.data
  } catch {
    return null
  }
}

export const createMySettings = async (data: UserSettings) => {
  const res = await api.post("/settings/me", data)
  return res.data
}

export const updateMySettings = async (data: UserSettings) => {
  const res = await api.put("/settings/me", data)
  return res.data
}

export const getAllSettings = async () => {
  const res = await api.get("/settings")
  return res.data
}

export const getMyProfile = async () => {
  const res = await api.get("/auth/me")
  return res.data
}

export const updateMyProfile = async (id: number, data: { first_name?: string; last_name?: string; email?: string }) => {
  const res = await api.put(`/users/${id}`, data)
  return res.data
}

// ==================== ALERTS ====================

export interface AlertEntry {
  id: number
  server: string
  service: string
  severity: string
  status: string
  description: string
  comment?: string
  started_at: string
}

export const getAlerts = async (params?: { page?: number }) => {
  const res = await api.get("/alerts", { params })
  return res.data
}

export const updateAlert = async (id: number, data: { status?: string; comment?: string }) => {
  const res = await api.patch(`/alerts/${id}`, data)
  return res.data
}

// ==================== MONITORING ====================

export interface MonitoringServer {
  id: number
  name: string
  ip: string
  zone?: string
  status: string
  supervised: boolean
  services?: string[]
}

export const getMonitoringOverview = async () => {
  const res = await api.get("/monitoring/overview")
  return res.data
}

export const getMonitoringRecords = async (params?: { page?: number; vm_ip?: string }) => {
  const res = await api.get("/monitoring", { params })
  return res.data
}

export const getMonitoringRecord = async (id: number) => {
  const res = await api.get(`/monitoring/${id}`)
  return res.data
}

export const collectMonitoringData = async (data: { vm_ip?: string; username: string }) => {
  const res = await api.post("/monitoring/collect", data)
  return res.data
}

export const syncDeploymentIp = async (data: { instance_id: string; vm_ip: string }) => {
  const res = await api.post("/monitoring/sync-ip", data)
  return res.data
}

// ==================== DASHBOARD ====================

export const getDashboardSummary = async () => {
  const res = await api.get("/dashboard/summary")
  return res.data
}

export const getDashboardServers = async () => {
  const res = await api.get("/dashboard/servers")
  return res.data
}

// ==================== TERRAFORM ====================

export const runDeployment = async (payload: any) => {
  const res = await api.post("/terraform/deploy", payload)
  return res.data
}

// ==================== VMS (PROXMOX) ====================

export interface VmInfo {
  vm_id: number
  name?: string
  status?: string
  instance_id?: string
}

export const listVms = async () => {
  const res = await api.get("/vms")
  return res.data
}

export const startVm = async (id: number) => {
  const res = await api.post(`/vms/${id}/start`)
  return res.data
}

export const stopVm = async (id: number) => {
  const res = await api.post(`/vms/${id}/stop`)
  return res.data
}

export const deleteVm = async (data: { vm_id: number; instance_id: string }) => {
  const res = await api.post("/vms/delete", data)
  return res.data
}

export const checkVmStatus = async (data: { vm_id: number; ip_address: string }) => {
  const res = await api.post("/vms/check-status", data)
  return res.data
}

export const convertVmToTemplate = async (vm_id: number) => {
  const res = await api.post("/vms/convert", { vm_id })
  return res.data
}

export const getConversionHistory = async () => {
  const res = await api.get("/vms/conversions")
  return res.data
}

// ==================== SERVICE TEMPLATES ====================

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

export interface Template {
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

export const listTemplates = async () => {
  const res = await api.get("/templates")
  return res.data
}

export const createTemplate = async (data: Omit<Template, "id">) => {
  const res = await api.post("/templates", data)
  return res.data
}

export const getTemplate = async (id: number) => {
  const res = await api.get(`/templates/${id}`)
  return res.data
}

export const updateTemplate = async (id: number, data: Partial<Omit<Template, "id">>) => {
  const res = await api.put(`/templates/${id}`, data)
  return res.data
}

export const deleteTemplate = async (id: number) => {
  const res = await api.delete(`/templates/${id}`)
  return res.data
}

export const generateScript = async (template_id: number, config_data: Record<string, any>) => {
  const res = await api.post("/templates/generate", { template_id, config_data })
  return res.data
}

export const logout = () => {
  removeAuthToken()
}

