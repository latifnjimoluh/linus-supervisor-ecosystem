import { defineConfig } from 'vite';

const API_URL = process.env.VITE_API_URL || 'http://localhost:3000';

// https://vitejs.dev/config/
export default defineConfig({
  server: {
    proxy: {
      '/api': {
        target: API_URL,
        changeOrigin: true,
        rewrite: (path) => path.replace(/^\/api/, ''),
      },
    },
  },
});
