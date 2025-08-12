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
  deploymentStats: { total: number; success: number; failed: number; deleted: number };
}

export const getDashboard = async (): Promise<DashboardData> => {
  const res = await api.get("/dashboard");
  return res.data;
};

export interface DeploymentStatsResponse {
  totals: { deployed: number; success: number; failed: number; deleted: number };
  timeline: Array<{ period: string; deployed: number; deleted: number; success: number; failed: number }>;
}

export const getDeploymentStats = async (
  period: "day" | "week" | "month" = "day"
): Promise<DeploymentStatsResponse> => {
  const res = await api.get(`/dashboard/stats?period=${period}`);
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

export const getDashboardInsights = async (): Promise<string> => {
  const res = await api.get("/dashboard/insights");
  return res.data.analysis;
};
