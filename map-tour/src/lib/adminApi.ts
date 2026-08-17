import type { ImportCommitSummary, ParsedImport } from './importTypes';

const API_BASE_URL = import.meta.env.VITE_API_URL ?? '/api';
const ADMIN_KEY_STORAGE_KEY = 'map-tour-admin-key';

export function getAdminKey(): string {
  return sessionStorage.getItem(ADMIN_KEY_STORAGE_KEY) ?? '';
}

export function setAdminKey(key: string): void {
  sessionStorage.setItem(ADMIN_KEY_STORAGE_KEY, key);
}

async function readErrorMessage(response: Response): Promise<string> {
  try {
    const body = (await response.json()) as { error?: string };
    return body.error ?? `Lỗi HTTP ${response.status}`;
  } catch {
    return `Lỗi HTTP ${response.status}`;
  }
}

export async function parseImportFile(file: File): Promise<ParsedImport> {
  const formData = new FormData();
  formData.append('file', file);
  const response = await fetch(`${API_BASE_URL}/admin/import/parse`, {
    method: 'POST',
    headers: { 'x-admin-key': getAdminKey() },
    body: formData,
  });
  if (!response.ok) throw new Error(await readErrorMessage(response));
  return response.json();
}

export async function commitImport(parsed: ParsedImport): Promise<ImportCommitSummary> {
  const response = await fetch(`${API_BASE_URL}/admin/import/commit`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json', 'x-admin-key': getAdminKey() },
    body: JSON.stringify(parsed),
  });
  if (!response.ok) throw new Error(await readErrorMessage(response));
  return response.json();
}
