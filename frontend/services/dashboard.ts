import { api } from "./api";

export interface DashboardData {
  totalVms: number;
  activeServices: number;
  alerts: { critical: number; major: number; minor: number };
  systemHealth: number;
  networkTraffic: { incoming: number; outgoing: number };
  recentActivity: Array<{ id: string; type: string; message: string; timestamp: string }>;
  lastUpdated: string;
  apiError: boolean;
}

export const getDashboard = async (): Promise<DashboardData> => {
  const res = await api.get("/dashboard");
  return res.data;
};

export interface InfrastructureServer {
  id: string;
  name: string;
  ip: string;
  zone: string;
  role: string;
  status: "ok" | "alert" | "unsupervised" | "unknown";
  uptime: string;
  position: { x: number; y: number };
  isTemplate: boolean;
}

export const getInfrastructureMap = async (): Promise<InfrastructureServer[]> => {
  const res = await api.get("/dashboard/map");
  return res.data;
};
