import { Pool } from 'pg';
import { env } from './env.js';

export const pool = new Pool({
  host: env.postgresHost,
  port: env.postgresPort,
  database: env.postgresDb,
  user: env.postgresUser,
  password: env.postgresPassword,
});
