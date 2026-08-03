import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

export default defineConfig({
  plugins: [react()],
  // maplibre-gl loads its worker via a `new URL(..., import.meta.url)` that
  // Vite's esbuild-based dep pre-bundler doesn't relocate correctly, causing
  // a missing "maplibre-gl-worker.mjs" file in node_modules/.vite/deps.
  optimizeDeps: {
    exclude: ['maplibre-gl'],
  },
  server: {
    proxy: {
      '/api': {
        target: process.env.VITE_API_PROXY_TARGET ?? 'http://localhost:8787',
        changeOrigin: true,
      },
    },
  },
});
