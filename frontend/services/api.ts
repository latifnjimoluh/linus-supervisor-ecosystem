import axios from "axios";

// By default point to the backend server running on port 3001
// unless an explicit URL is provided via environment variables.
const apiUrl = process.env.NEXT_PUBLIC_API_URL || "http://localhost:3001";

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

api.interceptors.request.use(
  (config) => {
    const token = getAuthToken();
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => Promise.reject(error)
);

api.interceptors.response.use(
  (response) => response,
  (error) => {
    const status = error.response?.status;
    const message =
      error.response?.data?.message ||
      error.response?.data?.error ||
      error.message ||
      "Erreur inconnue";

    const logger = status && status < 500 ? console.warn : console.error;
    logger("Erreur API:", message);

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
  password: string
): Promise<any> => {
  const response = await api.post("/auth/login", {
    email,
    password,
  });
  if (response.data && response.data.token) {
    setAuthToken(response.data.token);
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

export const logoutUser = (): void => {
  removeAuthToken();
};
