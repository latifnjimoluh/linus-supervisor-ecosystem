import axios from 'axios';

// Vite exposes env variables under import.meta.env
const baseURL = import.meta.env.VITE_API_URL || 'http://localhost:3000';

const client = axios.create({ baseURL });

client.interceptors.request.use((config) => {
  const token = localStorage.getItem('token');
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

client.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response) {
      if (error.response.status === 401) {
        localStorage.removeItem('token');
        localStorage.removeItem('tokenExpiry');
      } else if (error.response.status === 403) {
        window.location = '/403';
      } else if (error.response.status >= 500) {
        const msg =
          error.response.data?.message || 'Erreur interne du serveur';
        localStorage.setItem('lastError', msg);
        window.location = '/error';
      }
    }
    return Promise.reject(error);
  }
);

export default client;
