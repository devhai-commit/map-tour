import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import { copyFileSync, mkdirSync } from 'node:fs';
import { resolve } from 'node:path';

function copyMapLibreSharedModule() {
  let outputDirectory = '';

  return {
    name: 'copy-maplibre-shared-module',
    configResolved(config: { root: string; build: { outDir: string } }) {
      outputDirectory = resolve(config.root, config.build.outDir);
    },
    closeBundle() {
      const assetsDirectory = resolve(outputDirectory, 'assets');
      mkdirSync(assetsDirectory, { recursive: true });
      copyFileSync(
        resolve('node_modules/maplibre-gl/dist/maplibre-gl-shared.mjs'),
        resolve(assetsDirectory, 'maplibre-gl-shared.mjs'),
      );
    },
  };
}

export default defineConfig({
  plugins: [react(), copyMapLibreSharedModule()],
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
