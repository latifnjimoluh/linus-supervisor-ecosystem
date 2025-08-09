import { api } from "./api";

export interface Permission {
  id: number;
  name: string;
  description: string;
  status?: string;
  created_at?: string;
  updated_at?: string;
}

export interface PermissionList {
  data: Permission[];
  pagination: {
    total: number;
    page: number;
    pages: number;
    limit: number;
  };
}

export const listPermissions = async (page = 1, limit = 10): Promise<PermissionList> => {
  const res = await api.get("/permissions", { params: { page, limit } });
  return res.data;
};

export const getPermission = async (id: number): Promise<Permission> => {
  const res = await api.get(`/permissions/${id}`);
  return res.data;
};

export const createPermission = async (data: { name: string; description: string }): Promise<Permission> => {
  const res = await api.post("/permissions", data);
  // backend may return { message, data }
  return res.data.permission ?? res.data.data?.[0] ?? res.data;
};

export const updatePermission = async (id: number, data: { name?: string; description?: string }): Promise<Permission> => {
  const res = await api.put(`/permissions/${id}`, data);
  return res.data.permission ?? res.data;
};

export const deletePermission = async (id: number): Promise<any> => {
  const res = await api.delete(`/permissions/${id}`);
  return res.data;
};

export const assignPermissions = async (role_id: number, permission_ids: number[]): Promise<any> => {
  const res = await api.post("/permissions/assign", [{ role_id, permission_ids }]);
  return res.data;
};

export const unassignPermissions = async (role_id: number, permission_ids: number[]): Promise<any> => {
  const res = await api.post("/permissions/unassign", [{ role_id, permission_ids }]);
  return res.data;
};

export const getPermissionsByRole = async (role_id: number): Promise<Permission[]> => {
  const res = await api.get(`/permissions/role/${role_id}`);
  return res.data;
};
