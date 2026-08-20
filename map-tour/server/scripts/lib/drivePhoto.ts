// Google Drive "view" links (from cell hyperlinks in the survey workbook) are
// not directly downloadable — this resolves a share link to its file id, then
// fetches the raw bytes via Drive's direct-download endpoint. iPhone photos
// come back as HEIC, which browsers other than Safari can't render, so those
// get transcoded to JPEG via a local ffmpeg (sharp's bundled libheif rejects
// several of the real HEIC files here with "Security limit exceeded" on their
// multi-image containers — ffmpeg's demuxer handles them fine).
import { execFile } from 'node:child_process';
import fs from 'node:fs/promises';
import os from 'node:os';
import path from 'node:path';
import { promisify } from 'node:util';

const execFileAsync = promisify(execFile);

export type DownloadedKind = 'anh' | 'ban_ve' | 'video';

export interface DownloadedFile {
  buffer: Buffer;
  extension: string;
  kind: DownloadedKind;
}

const HEIC_EXTENSIONS = new Set(['heic', 'heif']);
const IMAGE_EXTENSIONS = new Set(['jpg', 'jpeg', 'png', 'webp', 'gif', 'bmp', 'tif', 'tiff']);
const DRAWING_EXTENSIONS = new Set(['pdf']);
const VIDEO_EXTENSIONS = new Set(['mp4', 'mov', 'avi', 'mkv', 'webm']);

export function driveFileId(url: string): string | null {
  const match = url.match(/drive\.google\.com\/file\/d\/([^/?]+)/);
  return match ? match[1] : null;
}

function extensionFromContentDisposition(header: string | null): string | null {
  if (!header) return null;
  const match = header.match(/filename\*?=(?:UTF-8'')?"?([^";]+)"?/i);
  if (!match) return null;
  const filename = decodeURIComponent(match[1]);
  const ext = filename.split('.').pop();
  return ext ? ext.toLowerCase() : null;
}

function extensionFromMagicBytes(buffer: Buffer): string | null {
  if (buffer.length < 12) return null;
  if (buffer[0] === 0xff && buffer[1] === 0xd8) return 'jpg';
  if (buffer.toString('ascii', 0, 4) === '\x89PNG') return 'png';
  if (buffer.toString('ascii', 0, 3) === 'GIF') return 'gif';
  if (buffer.toString('ascii', 0, 4) === '%PDF') return 'pdf';
  if (buffer.toString('ascii', 0, 4) === 'RIFF' && buffer.toString('ascii', 8, 12) === 'WEBP') return 'webp';
  const brand = buffer.toString('ascii', 4, 12);
  if (brand.startsWith('ftyp') && /he[iv][cx]|mif1/.test(brand)) return 'heic';
  return null;
}

async function transcodeHeicToJpeg(buffer: Buffer): Promise<Buffer> {
  const tmpDir = os.tmpdir();
  const inputPath = path.join(tmpDir, `drive-photo-${Date.now()}-${Math.random().toString(36).slice(2)}.heic`);
  const outputPath = `${inputPath}.jpg`;
  await fs.writeFile(inputPath, buffer);
  try {
    await execFileAsync('ffmpeg', ['-y', '-i', inputPath, '-frames:v', '1', '-q:v', '3', outputPath]);
    return await fs.readFile(outputPath);
  } finally {
    await fs.rm(inputPath, { force: true });
    await fs.rm(outputPath, { force: true });
  }
}

function classifyKind(extension: string): DownloadedKind | null {
  if (VIDEO_EXTENSIONS.has(extension)) return 'video';
  if (DRAWING_EXTENSIONS.has(extension)) return 'ban_ve';
  if (IMAGE_EXTENSIONS.has(extension)) return 'anh';
  return null;
}

// Returns null when the link isn't a downloadable file (Drive interstitial
// page, unrecognized format, or the request failed) — callers log and skip.
export async function downloadDriveFile(fileId: string): Promise<DownloadedFile | null> {
  const response = await fetch(`https://drive.google.com/uc?export=download&id=${fileId}`, { redirect: 'follow' });
  if (!response.ok) return null;

  const contentType = response.headers.get('content-type') ?? '';
  if (contentType.startsWith('text/html')) return null;

  const buffer = Buffer.from(await response.arrayBuffer());
  // Magic bytes (actual content) take priority over the Content-Disposition
  // filename: some 360° photos come through with a vendor-specific extension
  // (e.g. Insta360's ".insp") that isn't a real format — the bytes are a
  // perfectly ordinary equirectangular JPEG underneath, but trusting the
  // filename rejected them outright. Magic-byte sniffing doesn't cover video
  // containers, so those still fall through to the filename extension.
  const extension = extensionFromMagicBytes(buffer) ?? extensionFromContentDisposition(response.headers.get('content-disposition'));
  if (!extension) return null;

  if (HEIC_EXTENSIONS.has(extension)) {
    const jpeg = await transcodeHeicToJpeg(buffer);
    return { buffer: jpeg, extension: 'jpg', kind: 'anh' };
  }

  const kind = classifyKind(extension);
  if (!kind) return null;
  return { buffer, extension, kind };
}
