import { api } from "./api";

/* =========================================================
 * Constantes & helpers de stockage
 * ======================================================= */

export const ACCESS_TOKEN_KEY = "token";
export const REFRESH_TOKEN_KEY = "refreshToken";
export const DEVICE_ID_KEY = "device_id";

/** Enregistre les tokens en localStorage (optionnel, à appeler depuis tes pages) */
export function saveTokens(opts: {
  token?: string;
  refreshToken?: string;
  device_id?: string;
}) {
  if (typeof window === "undefined") return;
  if (opts.token) {
    localStorage.setItem(ACCESS_TOKEN_KEY, opts.token);
    api.defaults.headers.common["Authorization"] = `Bearer ${opts.token}`;
  }
  if (opts.refreshToken) {
    localStorage.setItem(REFRESH_TOKEN_KEY, opts.refreshToken);
  }
  if (opts.device_id) {
    localStorage.setItem(DEVICE_ID_KEY, opts.device_id);
  }
}

/** Charge le token en mémoire (ex: au boot de l’app) */
export function loadAccessTokenFromStorage() {
  if (typeof window === "undefined") return;
  const t = localStorage.getItem(ACCESS_TOKEN_KEY);
  if (t) api.defaults.headers.common["Authorization"] = `Bearer ${t}`;
}

/** Supprime les tokens du stockage + header */
export function clearTokens() {
  if (typeof window === "undefined") return;
  localStorage.removeItem(ACCESS_TOKEN_KEY);
  localStorage.removeItem(REFRESH_TOKEN_KEY);
  localStorage.removeItem(DEVICE_ID_KEY);
  delete api.defaults.headers.common["Authorization"];
}

/* =========================================================
 * Types
 * ======================================================= */

export type LoginResponse = {
  status: number;
  message?: string;
  token?: string;
  user?: {
    id: number | string;
    first_name?: string;
    last_name?: string;
    email: string;
    role?: string;
  };
  refreshToken?: string;
  device_id?: string;
};

export type MeResponse = {
  id: number | string;
  first_name?: string;
  last_name?: string;
  email: string;
  role?: string;
};

/* =========================================================
 * Auth (login en 1 ou 2 temps)
 * ======================================================= */

/**
 * Étape 1 : login/password (+ remember).
 * - 200 => connexion sans 2FA (token dans res.data)
 * - 206 => 2FA requise (aucun token, message "Code 2FA requis.")
 * On n’échoue PAS sur 206 : validateStatus => true
 */
export const loginUser = async (
  email: string,
  password: string,
  remember: boolean
): Promise<LoginResponse> => {
  const res = await api.post(
    "/auth/login",
    { email, password, remember },
    { validateStatus: () => true }
  );
  return { status: res.status, ...(res.data || {}) };
};

/**
 * Étape 2 : on renvoie le même endpoint mais avec l’OTP.
 * - 200 => token valide
 * - 401 => code OTP invalide
 * idem: validateStatus => true pour laisser la page gérer l’UI
 */
export const loginWithOtp = async (
  email: string,
  password: string,
  otp: string,
  remember: boolean
): Promise<LoginResponse> => {
  const res = await api.post(
    "/auth/login",
    { email, password, otp, remember },
    { validateStatus: () => true }
  );
  return { status: res.status, ...(res.data || {}) };
};

/* =========================================================
 * Changement / Reset de mot de passe
 * ======================================================= */

export const changePassword = async (
  currentPassword: string,
  newPassword: string
): Promise<any> => {
  const res = await api.post("/auth/change-password", {
    currentPassword,
    newPassword,
  });
  return res.data;
};

export const requestPasswordReset = async (email: string): Promise<any> => {
  const res = await api.post("/auth/request-reset", { email });
  return res.data;
};

export const resetPasswordWithCode = async (
  code: string,
  password: string
): Promise<any> => {
  const res = await api.post("/auth/reset-password", { code, password });
  return res.data;
};

/* =========================================================
 * 2FA (paramétrage sur la page Compte)
 * ======================================================= */

export const setup2FA = async (): Promise<{ secret: string; qr: string }> => {
  const res = await api.post("/auth/2fa/setup");
  return res.data;
};

export const verify2FA = async (token: string): Promise<any> => {
  const res = await api.post("/auth/2fa/verify", { token });
  return res.data;
};

export const disable2FA = async (): Promise<any> => {
  const res = await api.post("/auth/2fa/disable");
  return res.data;
};

/* =========================================================
 * Profil / Session / Refresh
 * ======================================================= */

export const getMe = async (): Promise<MeResponse> => {
  const res = await api.get("/auth/me");
  return res.data;
};

/**
 * Logout (optionnel si tu gères le refresh côté client)
 * - Essaie d’envoyer le refreshToken si présent côté client.
 * - Nettoie localStorage + Authorization header.
 */
export const logout = async () => {
  try {
    const refreshToken =
      typeof window !== "undefined"
        ? localStorage.getItem(REFRESH_TOKEN_KEY) || undefined
        : undefined;

    await api.post(
      "/auth/logout",
      { refreshToken },
      { validateStatus: () => true } // on ne bloque pas si RT invalide
    );
  } finally {
    clearTokens();
  }
};

/**
 * Refresh du token d’accès (si tu utilises remember + RefreshTokens côté backend)
 * - Nécessite refreshToken + device_id
 * - Renvoie { token } en cas de succès
 */
export const refreshAccessToken = async (): Promise<{
  status: number;
  token?: string;
  message?: string;
}> => {
  const refreshToken =
    typeof window !== "undefined"
      ? localStorage.getItem(REFRESH_TOKEN_KEY)
      : null;
  const device_id =
    typeof window !== "undefined" ? localStorage.getItem(DEVICE_ID_KEY) : null;

  if (!refreshToken || !device_id) {
    return { status: 400, message: "Refresh token ou device_id manquant." };
  }

  const res = await api.post(
    "/auth/refresh",
    { refreshToken, device_id },
    { validateStatus: () => true }
  );

  const data = { status: res.status, ...(res.data || {}) as any };
  if (res.status === 200 && data.token) {
    // mets à jour le header Authorization
    saveTokens({ token: data.token });
  }
  return data;
};
