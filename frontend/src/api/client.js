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
    if (error.response && error.response.status === 401) {
      // Optional: redirect to login or emit event
      localStorage.removeItem('token');
      localStorage.removeItem('tokenExpiry');
    }
    return Promise.reject(error);
  }
);

export default client;
