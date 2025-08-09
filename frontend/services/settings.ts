import { api } from "./api";

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

export const getMySettings = async (): Promise<UserSettings | null> => {
  try {
    const res = await api.get("/settings/me");
    return res.data;
  } catch (err) {
    console.error("getMySettings error", err);
    return null;
  }
};

export const createMySettings = async (data: UserSettings): Promise<UserSettings> => {
  const res = await api.post("/settings/me", data);
  return res.data;
};

export const updateMySettings = async (data: Partial<UserSettings>): Promise<UserSettings> => {
  const res = await api.put("/settings/me", data);
  return res.data;
};

export const listAllSettings = async (): Promise<UserSettings[]> => {
  const res = await api.get("/settings");
  return res.data;
};

