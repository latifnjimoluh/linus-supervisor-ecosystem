import axios from "axios";

const apiUrl = process.env.NEXT_PUBLIC_API_URL || "http://localhost:3000";

export const api = axios.create({
  baseURL: apiUrl,
});

export const getAuthToken = (): string | null => {
  if (typeof window !== "undefined") {
    return localStorage.getItem("token");
  }
  return null;
};

export const setAuthToken = (token: string): void => {
  if (typeof window !== "undefined") {
    localStorage.setItem("token", token);
  }
};

export const removeAuthToken = (): void => {
  if (typeof window !== "undefined") {
    localStorage.removeItem("token");
  }
};

api.interceptors.request.use(
  (config) => {
    const token = getAuthToken();
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => Promise.reject(error)
);

api.interceptors.response.use(
  (response) => response,
  (error) => {
    console.error("Erreur API:", error.message || "Erreur inconnue");
    if (error.message === "Network Error") {
      console.error(
        "Erreur réseau - Vérifiez votre connexion ou si le serveur est en cours d'exécution"
      );
    }
    if (error.code === "ECONNABORTED") {
      console.error(
        "La requête a expiré - Le serveur ne répond pas dans le délai imparti"
      );
    }
    return Promise.reject(error);
  }
);

export const loginUser = async (
  email: string,
  password: string
): Promise<any> => {
  const response = await api.post("/auth/login", {
    email,
    password,
  });
  if (response.data && response.data.token) {
    setAuthToken(response.data.token);
  }
  return response.data;
};

export const getUserProfile = async (): Promise<any> => {
  const response = await api.get("/auth/me");
  return response.data;
};

export const updateUserProfile = async (
  id: number,
  data: { first_name?: string; last_name?: string; email?: string }
): Promise<any> => {
  const response = await api.put(`/api/users/${id}`, data);
  return response.data;
};

export const logoutUser = (): void => {
  removeAuthToken();
};

export const registerUser = async (
  data: {
    first_name: string;
    last_name: string;
    email: string;
    password: string;
    role_id: number;
  }
): Promise<any> => {
  const response = await api.post("/auth/register", data);
  return response.data;
};

export const requestPasswordReset = async (
  email: string
): Promise<any> => {
  const response = await api.post("/auth/request-reset", { email });
  return response.data;
};

export const resetPassword = async (
  code: string,
  password: string
): Promise<any> => {
  const response = await api.post("/auth/reset-password", { code, password });
  return response.data;
};

export const getResetHistory = async (): Promise<any> => {
  const response = await api.get("/auth/reset-history");
  return response.data;
};

export const getRoles = async (): Promise<any[]> => {
  const response = await api.get("/roles");
  return response.data.data;
};

export const getRole = async (id: number): Promise<any> => {
  const response = await api.get(`/roles/${id}`);
  return response.data;
};

export const createRole = async (data: {
  name: string;
  description: string;
}): Promise<any> => {
  const response = await api.post("/roles", data);
  return response.data.role;
};

export const updateRole = async (
  id: number,
  data: { name?: string; description?: string }
): Promise<any> => {
  const response = await api.put(`/roles/${id}`, data);
  return response.data.role;
};

export const deleteRole = async (id: number): Promise<any> => {
  const response = await api.delete(`/roles/${id}`);
  return response.data;
};

export const createUser = async (
  data: {
    first_name: string;
    last_name: string;
    email: string;
    password: string;
    role_id: number;
  }
): Promise<any> => {
  const response = await api.post("/users", data);
  return response.data;
};

export const getUsers = async (): Promise<any[]> => {
  const response = await api.get("/users");
  return response.data;
};

export const getUser = async (id: number): Promise<any> => {
  const response = await api.get(`/users/${id}`);
  return response.data;
};

export const updateUser = async (
  id: number,
  data: { first_name?: string; last_name?: string; email?: string; role_id?: number }
): Promise<any> => {
  const response = await api.put(`/users/${id}`, data);
  return response.data;
};

export const patchUser = async (
  id: number,
  data: { [key: string]: any }
): Promise<any> => {
  const response = await api.patch(`/users/${id}`, data);
  return response.data;
};

export const deleteUser = async (id: number): Promise<any> => {
  const response = await api.delete(`/users/${id}`);
  return response.data;
};

export const searchUsers = async (query: string): Promise<any[]> => {
  const response = await api.get("/users/search", { params: { query } });
  return response.data;
};

export const getPermissions = async (page = 1): Promise<any[]> => {
  const response = await api.get("/permissions", { params: { page } });
  return response.data.data;
};

export const createPermission = async (data: {
  name: string;
  description: string;
}): Promise<any> => {
  const response = await api.post("/permissions", data);
  return Array.isArray(response.data.data)
    ? response.data.data[0]
    : response.data.data;
};

export const deletePermission = async (id: number): Promise<any> => {
  const response = await api.delete(`/permissions/${id}`);
  return response.data;
};

export const assignPermissions = async (
  assignments: { role_id: number; permission_ids: number[] }[]
): Promise<any> => {
  const response = await api.post("/permissions/assign", assignments);
  return response.data;
};

export const unassignPermissions = async (
  assignments: { role_id: number; permission_ids: number[] }[]
): Promise<any> => {
  const response = await api.post("/permissions/unassign", assignments);
  return response.data;
};

export const getPermissionsByRole = async (
  roleId: number
): Promise<any[]> => {
  const response = await api.get(`/permissions/role/${roleId}`);
  return response.data;
};

export const updatePermission = async (
  id: number,
  data: { name?: string; description?: string }
): Promise<any> => {
  const response = await api.put(`/permissions/${id}`, data);
  return response.data.permission;
};

export interface UserSettings {
  cloudinit_user?: string;
  cloudinit_password?: string;
  proxmox_api_url?: string;
  proxmox_api_token_id?: string;
  proxmox_api_token_name?: string;
  proxmox_api_token_secret?: string;
  pm_user?: string;
  pm_password?: string;
  proxmox_node?: string;
  vm_storage?: string;
  vm_bridge?: string;
  ssh_public_key_path?: string;
  ssh_private_key_path?: string;
  statuspath?: string;
  servicespath?: string;
  instanceinfopath?: string;
  proxmox_host?: string;
  proxmox_ssh_user?: string;
}

export const getMySettings = async (): Promise<UserSettings> => {
  const response = await api.get("/settings/me");
  return response.data;
};

export const createMySettings = async (data: UserSettings): Promise<UserSettings> => {
  const response = await api.post("/settings/me", data);
  return response.data;
};

export const updateMySettings = async (data: UserSettings): Promise<UserSettings> => {
  const response = await api.put("/settings/me", data);
  return response.data;
};

export const listSettings = async (): Promise<UserSettings[]> => {
  const response = await api.get("/settings");
  return response.data;
};

export interface FieldSchemaField {
  name: string;
  label: string;
  type: "text" | "number" | "boolean" | "select";
  required?: boolean;
  default?: string | number | boolean;
}

export interface FieldSchema {
  fields: FieldSchemaField[];
}

export interface Template {
  id: number;
  name: string;
  service_type?: string;
  category: string;
  description: string;
  type?: "template" | "script";
  template_content: string;
  script_path?: string;
  fields_schema?: FieldSchema;
}

export const listTemplates = async (): Promise<Template[]> => {
  const response = await api.get("/templates");
  return response.data;
};

export const createTemplate = async (
  data: Omit<Template, "id">
): Promise<Template> => {
  const response = await api.post("/templates", data);
  return response.data;
};

export const getTemplate = async (id: number): Promise<Template> => {
  const response = await api.get(`/templates/${id}`);
  return response.data;
};

export const updateTemplate = async (
  id: number,
  data: Partial<Omit<Template, "id">>
): Promise<Template> => {
  const response = await api.put(`/templates/${id}`, data);
  return response.data;
};

export const deleteTemplate = async (id: number): Promise<any> => {
  const response = await api.delete(`/templates/${id}`);
  return response.data;
};

export const generateTemplateScript = async (
  template_id: number,
  config_data: Record<string, string | number>
): Promise<{ script: string; template_id: number }> => {
  const response = await api.post("/templates/generate", {
    template_id,
    config_data,
  });
  return response.data;
};

export interface MonitoringRecord {
  id: number;
  vm_ip: string;
  ip_address?: string;
  instance_id?: string;
  services_status?: any;
  system_status?: any;
  retrieved_at: string;
}

export const listMonitoringRecords = async (
  params?: { page?: number; limit?: number; vm_ip?: string; q?: string }
): Promise<{ data: MonitoringRecord[]; pagination: any }> => {
  const response = await api.get("/monitoring", { params });
  return response.data;
};

export const getMonitoringRecord = async (
  id: number
): Promise<MonitoringRecord> => {
  const response = await api.get(`/monitoring/${id}`);
  return response.data;
};

export const collectMonitoringData = async (
  data: {
    vm_ip?: string;
    host?: string;
    username: string;
    privateKeyPath?: string;
    statusPath?: string;
    servicesPath?: string;
    instanceInfoPath?: string;
  }
): Promise<MonitoringRecord> => {
  const response = await api.post("/monitoring/collect", data);
  return response.data;
};

export const syncDeploymentIP = async (
  data: { instance_id: string; vm_ip: string }
): Promise<any> => {
  const response = await api.post("/monitoring/sync-ip", data);
  return response.data;
};

export const getMonitoringOverview = async (): Promise<{
  summary: { total: number; active: number; alert: number; unsupervised: number };
  servers: any[];
}> => {
  const response = await api.get("/monitoring/overview");
  return response.data;
};

export const runDeployment = async (
  data: {
    vm_names: string[];
    service_type: string;
    script_refs?: { type: string; id: number }[];
    template_name: string;
    memory_mb: number;
    vcpu_cores: number;
    vcpu_sockets: number;
    disk_size: string | number;
    use_static_ip: boolean;
    static_ip?: string;
    gateway?: string;
  }
): Promise<any> => {
  const response = await api.post("/terraform/deploy", data);
  return response.data;
};

export const getDashboardSummary = async (): Promise<any> => {
  const response = await api.get("/dashboard/summary");
  return response.data;
};

export const getDashboardServers = async (): Promise<any[]> => {
  const response = await api.get("/dashboard/servers");
  return response.data;
};

export interface InfrastructureServer {
  id: number;
  ip: string;
  name: string;
  zone: string;
}

export const listServers = async (): Promise<InfrastructureServer[]> => {
  const response = await api.get("/servers");
  return response.data;
};

export const getServer = async (id: number): Promise<InfrastructureServer> => {
  const response = await api.get(`/servers/${id}`);
  return response.data;
};

export const createServer = async (
  data: { ip: string; name: string; zone: string }
): Promise<InfrastructureServer> => {
  const response = await api.post("/servers", data);
  return response.data;
};

export const updateServer = async (
  id: number,
  data: Partial<{ ip: string; name: string; zone: string }>
): Promise<InfrastructureServer> => {
  const response = await api.put(`/servers/${id}`, data);
  return response.data;
};

export const deleteServer = async (id: number): Promise<any> => {
  const response = await api.delete(`/servers/${id}`);
  return response.data;
};

export interface AlertItem {
  id: number;
  status: string;
  [key: string]: any;
}

export const listAlerts = async (): Promise<AlertItem[]> => {
  const response = await api.get("/alerts");
  return response.data;
};

export const updateAlert = async (
  id: number,
  data: { status: string }
): Promise<AlertItem> => {
  const response = await api.patch(`/alerts/${id}`, data);
  return response.data;
};
