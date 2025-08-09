import { api } from "./api";

export interface User {
  id: number;
  first_name: string;
  last_name: string;
  email: string;
  role_id: number;
  status: string;
  created_at: string;
  last_login?: string;
  phone?: string;
  avatar?: string;
}

export const listUsers = async (): Promise<User[]> => {
  const res = await api.get("/users");
  return res.data.data ?? res.data;
};

export const getUser = async (id: number): Promise<User> => {
  const res = await api.get(`/users/${id}`);
  return res.data;
};

export const createUser = async (data: any): Promise<any> => {
  const res = await api.post("/users", data);
  return res.data;
};

export const updateUser = async (id: number, data: any): Promise<any> => {
  const res = await api.put(`/users/${id}`, data);
  return res.data;
};

export const patchUser = async (id: number, data: any): Promise<any> => {
  const res = await api.patch(`/users/${id}`, data);
  return res.data;
};

export const deleteUser = async (id: number): Promise<any> => {
  const res = await api.delete(`/users/${id}`);
  return res.data;
};

export const searchUsers = async (query: string): Promise<User[]> => {
  const res = await api.get("/users/search", { params: { query } });
  return res.data;
};
