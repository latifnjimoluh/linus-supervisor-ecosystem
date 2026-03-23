import { api } from "./api";

export async function runTraceroute(target: string): Promise<{ target: string; output: string }> {
  const res = await api.post("/network/traceroute", { target });
  return res.data;
}

export async function getSnmpInterfaceStatus(host: string, ifIndex: string, community = "public"): Promise<number> {
  const res = await api.get("/network/snmp/interface-status", {
    params: { host, ifIndex, community },
  });
  return res.data.status as number;
}
