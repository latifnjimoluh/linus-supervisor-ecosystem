import axios from "axios";

/* ========================================================================== *
 *                           GESTION DES REQUÊTES
 * ========================================================================== */

// --- Pending controllers pour annuler sur logout ---
const pendingControllers = new Set<AbortController>();

export const apiUrl = process.env.NEXT_PUBLIC_API_URL || "http://localhost:3000";
export const api = axios.create({ baseURL: apiUrl, timeout: 60_000 }); // 🔧 timeout raisonnable

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
    const payload = JSON.parse(
      atob(token.split(".")[1].replace(/-/g, "+").replace(/_/g, "/"))
    );
    if (!payload.exp) return false;
    return payload.exp * 1000 < Date.now();
  } catch {
    return true;
  }
};

const clearLocalData = (): void => {
  if (typeof window !== "undefined") {
    const keys = ["token", "role", "refresh_token", "device_id", "last_instance_id"];
    for (const k of keys) localStorage.removeItem(k);
  }
};

const cancelPendingRequests = (): void => {
  pendingControllers.forEach((c) => c.abort());
  pendingControllers.clear();
};

// 🔧 Endpoints d'auth publics (ne nécessitent pas le token)
const AUTH_PUBLIC_ENDPOINTS = new Set<string>([
  "/auth/login",
  "/auth/register",
  "/auth/refresh",
  "/auth/request-reset",
  "/auth/reset-password",
]);

// 🔧 Endpoints sensibles métier (on ne doit JAMAIS déconnecter l'utilisateur
// automatiquement suite à leur échec)
const NEVER_LOGOUT_ENDPOINTS = [
  "/deployments",      // lecture / suivi
  "/deploy",           // déclenchement
  "/logs",             // consultation des logs
  "/dashboard",        // map/infos
  "/chat",             // IAs internes
];

// 🔧 petit util: normaliser l'URL de la requête (path)
const pathOf = (url?: string) => {
  if (!url) return "";
  try {
    // axios passe souvent des chemins relatifs → on renvoie tel quel
    if (url.startsWith("/")) return url.split("?")[0];
    // sinon on tente d'en extraire le pathname
    const u = new URL(url, apiUrl);
    return u.pathname;
  } catch {
    return url;
  }
};

// ---------- Logout contrôlé ----------
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

/* ========================================================================== *
 *                           REFRESH DÉDOUBLONNÉ
 * ========================================================================== */

// 🔧 Un seul refresh en vol ; les autres appels attendent
let refreshInFlight: Promise<string | null> | null = null;

const performRefresh = async (): Promise<string | null> => {
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
      if (data.refreshToken) setRefreshToken(data.refreshToken);
      if (data.device_id) setDeviceId(data.device_id);
      return data.token as string;
    }
    return null;
  } catch {
    return null;
  }
};

export const refreshAuthToken = async (): Promise<string | null> => {
  if (!refreshInFlight) {
    refreshInFlight = (async () => {
      try {
        return await performRefresh();
      } finally {
        // libère le slot pour les prochaines fois
        refreshInFlight = null;
      }
    })();
  }
  return refreshInFlight;
};

/* ========================================================================== *
 *                             INTERCEPTEURS AXIOS
 * ========================================================================== */

// Request interceptor
api.interceptors.request.use(
  async (config) => {
    const controller = new AbortController();
    config.signal = controller.signal;
    (config as any)._controller = controller;
    pendingControllers.add(controller);

    const urlPath = pathOf(config.url);
    const isPublicAuth = AUTH_PUBLIC_ENDPOINTS.has(urlPath);

    // 🔧 N'ajoute le token que s'il existe.
    // 🔧 Surtout: ne JAMAIS déconnecter ici s'il n'y a pas de token.
    //     On laisse le serveur renvoyer 401 et on gère dans response interceptor.
    let token = getAuthToken();

    // Si token expiré, on tente un refresh AVANT d'envoyer la requête
    if (!isPublicAuth && token && isTokenExpired(token)) {
      token = await refreshAuthToken();
    }

    if (token) {
      config.headers = config.headers || {};
      (config.headers as any).Authorization = `Bearer ${token}`;
    }

    return config;
  },
  (error) => Promise.reject(error)
);

// Response interceptor
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
    const urlPath = pathOf(cfg.url);
    const isPublicAuth = AUTH_PUBLIC_ENDPOINTS.has(urlPath);
    const isNeverLogoutPath = NEVER_LOGOUT_ENDPOINTS.some((p) => urlPath.startsWith(p));

    const message =
      error.response?.data?.message ||
      error.response?.data?.error ||
      error.message ||
      "Erreur inconnue";

    const logger = status && status < 500 ? console.warn : console.error;
    logger("Erreur API:", message, { status, url: urlPath });

    // 🔧 JAMais de logout sur erreurs réseau/timeout
    if (error.message === "Network Error") {
      console.error("Erreur réseau - Vérifiez votre connexion ou si le serveur tourne");
      return Promise.reject(error);
    }
    if (error.code === "ECONNABORTED") {
      console.error("La requête a expiré - Le serveur ne répond pas dans le délai imparti");
      return Promise.reject(error);
    }

    // 🔧 401: tenter un refresh (dé-doublonné). Ne JAMAIS logout pour endpoints métiers sensibles.
    if (!isPublicAuth && status === 401 && !cfg._retry) {
      const newToken = await refreshAuthToken();
      if (newToken) {
        cfg._retry = true;
        cfg.headers = cfg.headers || {};
        cfg.headers.Authorization = `Bearer ${newToken}`;
        return api.request(cfg);
      }
      // Échec de refresh → on logout uniquement si ce n'est pas un endpoint sensible
      if (!isNeverLogoutPath) {
        await logoutUser("Session expirée");
      }
      return Promise.reject(error);
    }

    // 🔧 403: accès interdit → pas de logout ; on peut rediriger vers /forbidden
    if (!isPublicAuth && status === 403) {
      if (typeof window !== "undefined") {
        // Pas de logout ici.
        window.location.href = "/forbidden";
      }
      return Promise.reject(error);
    }

    // 🔧 5xx: ne JAMAIS déconnecter
    return Promise.reject(error);
  }
);

/* ========================================================================== *
 *                               APPELS API
 * ========================================================================== */

/**
 * Login 1er temps → email + password
 */
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
  // si OTP demandé → pas de token encore
  if (response.data?.token) setAuthToken(response.data.token);
  if (remember && response.data?.refreshToken) setRefreshToken(response.data.refreshToken);
  if (response.data?.device_id) setDeviceId(response.data.device_id);
  else if (deviceId) setDeviceId(deviceId);
  return { ...response.data, status: response.status };
};

/**
 * Login 2ème temps → OTP
 */
export const loginWithOtp = async (
  email: string,
  password: string,
  otp: string,
  remember = false
): Promise<any> => {
  let deviceId = getDeviceId();
  const payload: any = { email, password, otp, remember };
  if (deviceId) payload.device_id = deviceId;

  // IMPORTANT: récupérer {status, data} même en 401
  const response = await api.post("/auth/login", payload, {
    validateStatus: () => true,
  });

  if (response.data?.token) setAuthToken(response.data.token);
  if (remember && response.data?.refreshToken) setRefreshToken(response.data.refreshToken);
  if (response.data?.device_id) setDeviceId(response.data.device_id);

  return { ...response.data, status: response.status };
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
