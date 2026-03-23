import { api } from "./api";

export interface Role {
  id: number;
  name: string;
  description?: string;
  user_count?: number;
  is_system?: boolean;
  created_at?: string;
}

export const listRoles = async (): Promise<Role[]> => {
  const res = await api.get("/roles");
  return res.data.data ?? res.data;
};

export const getRole = async (id: number): Promise<Role> => {
  const res = await api.get(`/roles/${id}`);
  return res.data;
};

export const createRole = async (data: { name: string; description?: string }): Promise<Role> => {
  const res = await api.post("/roles", data);
  return res.data.role ?? res.data;
};

export const updateRole = async (id: number, data: { name: string; description?: string }): Promise<Role> => {
  const res = await api.put(`/roles/${id}`, data);
  return res.data.role ?? res.data;
};

export const deleteRole = async (id: number): Promise<any> => {
  const res = await api.delete(`/roles/${id}`);
  return res.data;
};
