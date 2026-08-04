import { config as loadDotenv } from 'dotenv';
import { fileURLToPath } from 'node:url';
import path from 'node:path';

const rootEnvPath = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '../../../.env');
// Does not override vars already set in process.env (e.g. by docker-compose's
// `environment:` block), only fills in what's missing for local `npm run dev`.
loadDotenv({ path: rootEnvPath });

function required(name: string): string {
  const value = process.env[name];
  if (!value) {
    throw new Error(`Missing required environment variable: ${name} (checked ${rootEnvPath} and process env)`);
  }
  return value;
}

export const env = {
  postgresHost: process.env.POSTGRES_HOST ?? '127.0.0.1',
  postgresPort: Number(process.env.POSTGRES_PORT ?? 5432),
  postgresDb: required('POSTGRES_DB'),
  postgresUser: required('POSTGRES_USER'),
  postgresPassword: required('POSTGRES_PASSWORD'),
  apiPort: Number(process.env.API_PORT ?? 8787),
  corsOrigin: process.env.CORS_ORIGIN ?? 'http://localhost:5173',
  osrmUrl: process.env.OSRM_URL ?? 'http://osrm:5000',
};
