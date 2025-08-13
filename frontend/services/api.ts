import axios from "axios";

// Track pending requests so we can abort them on logout
const pendingControllers = new Set<AbortController>();

// By default point to the backend server running on port 3000
// unless an explicit URL is provided via environment variables.
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

export const getRefreshToken = (): string | null => {
  if (typeof window !== "undefined") {
    return localStorage.getItem("refresh_token");
  }
  return null;
};

export const setRefreshToken = (token: string): void => {
  if (typeof window !== "undefined") {
    localStorage.setItem("refresh_token", token);
  }
};

export const removeRefreshToken = (): void => {
  if (typeof window !== "undefined") {
    localStorage.removeItem("refresh_token");
  }
};

export const getDeviceId = (): string | null => {
  if (typeof window !== "undefined") {
    return localStorage.getItem("device_id");
  }
  return null;
};

export const setDeviceId = (id: string): void => {
  if (typeof window !== "undefined") {
    localStorage.setItem("device_id", id);
  }
};

export const isTokenExpired = (token: string): boolean => {
  try {
    const payload = JSON.parse(atob(token.split(".")[1].replace(/-/g, "+").replace(/_/g, "/")));
    if (!payload.exp) return false;
    return payload.exp * 1000 < Date.now();
  } catch {
    return true;
  }
};

const clearLocalData = (): void => {
  if (typeof window !== "undefined") {
    const keys = [
      "token",
      "role",
      "refresh_token",
      "last_instance_id",
      "chatThread",
    ];
    for (const k of keys) localStorage.removeItem(k);
    Object.keys(localStorage)
      .filter((k) => k.startsWith("chat:"))
      .forEach((k) => localStorage.removeItem(k));
  }
};

const cancelPendingRequests = (): void => {
  pendingControllers.forEach((c) => c.abort());
  pendingControllers.clear();
};

let loggingOut = false;
export const logoutUser = async (reason?: string): Promise<void> => {
  if (loggingOut) return;
  loggingOut = true;
  try {
    const token = getAuthToken();
    const refresh = getRefreshToken();
    const deviceId = getDeviceId();
    if (token) {
      await fetch(`${apiUrl}/auth/logout`, {
        method: "POST",
        headers: {
          Authorization: `Bearer ${token}`,
          "Content-Type": "application/json",
        },
        body: JSON.stringify({ refreshToken: refresh, device_id: deviceId }),
      }).catch(() => {});
    }
  } finally {
    clearLocalData();
    cancelPendingRequests();
    if (typeof window !== "undefined") {
      const redirect = encodeURIComponent(
        window.location.pathname + window.location.search
      );
      window.localStorage.setItem(
        "logout_message",
        reason || "Vous avez été déconnecté."
      );
      window.location.href = `/login?redirect=${redirect}`;
    }
    loggingOut = false;
  }
};

export const refreshAuthToken = async (): Promise<string | null> => {
  const refresh = getRefreshToken();
  const deviceId = getDeviceId();
  if (!refresh || !deviceId) return null;
  try {
    const res = await fetch(`${apiUrl}/auth/refresh`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ refreshToken: refresh, device_id: deviceId }),
    });
    if (!res.ok) return null;
    const data = await res.json();
    if (data.token) {
      setAuthToken(data.token);
      return data.token;
    }
    return null;
  } catch {
    return null;
  }
};

api.interceptors.request.use(
  async (config) => {
    const controller = new AbortController();
    config.signal = controller.signal;
    (config as any)._controller = controller;
    pendingControllers.add(controller);
    const isAuthEndpoint = config.url?.startsWith("/auth/");
    if (!isAuthEndpoint) {
      let token = getAuthToken();
      if (!token) {
        token = await refreshAuthToken();
      }
      if (token) {
        config.headers.Authorization = `Bearer ${token}`;
      } else {
        pendingControllers.delete(controller);
        logoutUser();
        return Promise.reject(new Error("No auth token"));
      }
    }
    return config;
  },
  (error) => Promise.reject(error)
);

api.interceptors.response.use(
  (response) => {
    const ctrl = (response.config as any)._controller;
    if (ctrl) pendingControllers.delete(ctrl);
    return response;
  },
  async (error) => {
    const ctrl = (error.config as any)?._controller;
    if (ctrl) pendingControllers.delete(ctrl);
    const status = error.response?.status;
    const isAuthEndpoint = error.config?.url?.startsWith("/auth/");
    const message =
      error.response?.data?.message ||
      error.response?.data?.error ||
      error.message ||
      "Erreur inconnue";

    const logger = status && status < 500 ? console.warn : console.error;
    logger("Erreur API:", message);

    if (!isAuthEndpoint && status === 401 && !error.config?._retry) {
      const newToken = await refreshAuthToken();
      if (newToken) {
        error.config._retry = true;
        error.config.headers.Authorization = `Bearer ${newToken}`;
        return api.request(error.config);
      }
      logoutUser("Session expirée");
    } else if (!isAuthEndpoint && status === 401) {
      logoutUser("Session expirée");
    } else if (!isAuthEndpoint && status === 403) {
      if (typeof window !== "undefined") {
        window.location.href = "/forbidden";
      }
    }

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
  password: string,
  remember = false
): Promise<any> => {
  let deviceId = getDeviceId();
  const payload: any = { email, password, remember };
  if (remember) {
    if (!deviceId && typeof crypto !== "undefined" && (crypto as any).randomUUID) {
      deviceId = (crypto as any).randomUUID();
    }
    if (deviceId) payload.device_id = deviceId;
  }
  const response = await api.post("/auth/login", payload);
  if (response.data?.token) {
    setAuthToken(response.data.token);
  }
  if (remember && response.data?.refreshToken) {
    setRefreshToken(response.data.refreshToken);
  }
  if (response.data?.device_id) {
    setDeviceId(response.data.device_id);
  } else if (deviceId) {
    setDeviceId(deviceId);
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
