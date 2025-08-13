import { api } from "./api";

export interface DashboardData {
  totalVms: number;
  activeServices: number;
  alerts: { critical: number; major: number; minor: number };
  systemHealth: number;
  networkTraffic: { incoming: number; outgoing: number };
  recentActivity: Array<{ id: string; type: string; message: string; timestamp: string }>;
  lastUpdated: string | null;
  server_tz?: string;
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
  successRate7d: number;
  successRate30d: number;
  medianDeploymentTimeSec: number;
  topFailureCauses: Array<{ cause: string; count: number }>;
  storageCapacity: Array<{ datastore: string; free: number; total: number }>;
  deploymentsByZone: Record<string, number>;
  avgDestroyTimeSec: number;
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

export interface InfrastructureMapResponse {
  status: "ok" | "degraded";
  servers: InfrastructureServer[];
  errors?: string[];
}

export const getInfrastructureMap = async (): Promise<InfrastructureMapResponse> => {
  const res = await api.get("/dashboard/map");
  return res.data;
};

export const getDashboardInsights = async (
  period: "day" | "week" | "month" = "day"
): Promise<string> => {
  const res = await api.get(`/dashboard/insights?period=${period}`);
  return res.data.analysis;
};
