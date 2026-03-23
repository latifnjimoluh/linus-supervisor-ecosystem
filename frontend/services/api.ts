import axios from "axios";

// --- Pending controllers pour annuler sur logout ---
const pendingControllers = new Set<AbortController>();

const apiUrl = process.env.NEXT_PUBLIC_API_URL || "http://localhost:3000";

export const api = axios.create({ baseURL: apiUrl });

// ---- Local storage helpers ----
export const getAuthToken = (): string | null =>
  typeof window !== "undefined" ? localStorage.getItem("token") : null;

export const setAuthToken = (token: string): void => {
  if (typeof window !== "undefined") localStorage.setItem("token", token);
};

export const removeAuthToken = (): void => {
  if (typeof window !== "undefined") localStorage.removeItem("token");
};

export const getRefreshToken = (): string | null =>
  typeof window !== "undefined" ? localStorage.getItem("refresh_token") : null;

export const setRefreshToken = (token: string): void => {
  if (typeof window !== "undefined") localStorage.setItem("refresh_token", token);
};

export const removeRefreshToken = (): void => {
  if (typeof window !== "undefined") localStorage.removeItem("refresh_token");
};

export const getDeviceId = (): string | null =>
  typeof window !== "undefined" ? localStorage.getItem("device_id") : null;

export const setDeviceId = (id: string): void => {
  if (typeof window !== "undefined") localStorage.setItem("device_id", id);
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
    const keys = ["token", "role", "refresh_token", "last_instance_id", "chatThread"];
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
      const redirect = encodeURIComponent(window.location.pathname + window.location.search);
      window.localStorage.setItem("logout_message", reason || "Vous avez été déconnecté.");
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

// Endpoints “publiques” qui ne nécessitent pas d’attacher/rafraîchir le token
const AUTH_PUBLIC_ENDPOINTS = new Set<string>([
  "/auth/login",
  "/auth/register",
  "/auth/refresh",
  "/auth/request-reset",
  "/auth/reset-password",
]);

api.interceptors.request.use(
  async (config) => {
    const controller = new AbortController();
    config.signal = controller.signal;
    (config as any)._controller = controller;
    pendingControllers.add(controller);

    const url = config.url || "";
    const isPublicAuth = AUTH_PUBLIC_ENDPOINTS.has(url);

    // Attache le token si disponible (même sur /auth/me)
    let token = getAuthToken();

    // Rafraîchis *proactivement* si expiré et pas endpoint public
    if (!isPublicAuth && token && isTokenExpired(token)) {
      token = await refreshAuthToken();
    }

    if (token) {
      config.headers = config.headers || {};
      (config.headers as any).Authorization = `Bearer ${token}`;
    }

    // Si la route n’est pas publique et qu’on n’a *vraiment* pas de token, on logout
    if (!isPublicAuth && !token) {
      pendingControllers.delete(controller);
      logoutUser("Session expirée");
      return Promise.reject(new Error("No auth token"));
    }

    return config;
  },
  (error) => Promise.reject(error)
);

api.interceptors.response.use(
  (response) => {
    const ctrl = (response.config as any)?._controller;
    if (ctrl) pendingControllers.delete(ctrl);
    return response;
  },
  async (error) => {
    const cfg = error.config || {};
    const ctrl = cfg._controller;
    if (ctrl) pendingControllers.delete(ctrl);

    const status = error.response?.status;
    const url = cfg.url || "";
    const isPublicAuth = AUTH_PUBLIC_ENDPOINTS.has(url);

    const message =
      error.response?.data?.message || error.response?.data?.error || error.message || "Erreur inconnue";

    const logger = status && status < 500 ? console.warn : console.error;
    logger("Erreur API:", message);

    // Retry unique après refresh si 401 sur endpoint protégé
    if (!isPublicAuth && status === 401 && !cfg._retry) {
      const newToken = await refreshAuthToken();
      if (newToken) {
        cfg._retry = true;
        cfg.headers = cfg.headers || {};
        cfg.headers.Authorization = `Bearer ${newToken}`;
        return api.request(cfg);
      }
      await logoutUser("Session expirée");
      return Promise.reject(error);
    }

    if (!isPublicAuth && status === 403) {
      if (typeof window !== "undefined") {
        window.location.href = "/forbidden";
      }
    }

    if (error.message === "Network Error") {
      console.error("Erreur réseau - Vérifiez votre connexion ou si le serveur est en cours d'exécution");
    }
    if (error.code === "ECONNABORTED") {
      console.error("La requête a expiré - Le serveur ne répond pas dans le délai imparti");
    }
    return Promise.reject(error);
  }
);

// ---- API calls ----
export const loginUser = async (email: string, password: string, remember = false): Promise<any> => {
  let deviceId = getDeviceId();
  const payload: any = { email, password, remember };
  if (remember) {
    if (!deviceId && typeof crypto !== "undefined" && (crypto as any).randomUUID) {
      deviceId = (crypto as any).randomUUID();
    }
    if (deviceId) payload.device_id = deviceId;
  }
  const response = await api.post("/auth/login", payload);
  if (response.data?.token) setAuthToken(response.data.token);
  if (remember && response.data?.refreshToken) setRefreshToken(response.data.refreshToken);
  if (response.data?.device_id) setDeviceId(response.data.device_id);
  else if (deviceId) setDeviceId(deviceId);
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
  const response = await api.put(`/users/${id}`, data);
  return response.data;
};
