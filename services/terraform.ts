import { api } from "./api";

export interface ScriptRef {
  type: "script" | "config" | "template";
  id: number;
}

export interface DeployPayload {
  vm_names: string[];
  service_type: string;
  script_refs?: ScriptRef[];
  template_name: string;
  memory_mb: number;
  vcpu_cores: number;
  vcpu_sockets: number;
  disk_size: string;
  use_static_ip: boolean;
  static_ip?: string;
  gateway?: string;
}

export interface DeployResponse {
  message: string;
  output: string;
  log: string;
  vm_ips: Record<string, string>;
  vm_names: string[];
  ssh_commands: Record<string, string>;
  vm_ids: Record<string, string>;
  instance_id: string;
}

export const runDeployment = async (
  payload: DeployPayload
): Promise<DeployResponse> => {
  const res = await api.post("/terraform/deploy", payload);
  return res.data;
};

