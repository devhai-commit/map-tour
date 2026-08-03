# Backup CSDL ra file .sql.gz trong backups/ (Windows).
# Chạy: pwsh scripts/backup.ps1
$ErrorActionPreference = 'Stop'

$DbDir = Split-Path -Parent $PSScriptRoot
. "$PSScriptRoot\_env.ps1"

$BackupDir = Join-Path $DbDir 'backups'
New-Item -ItemType Directory -Force -Path $BackupDir | Out-Null

$envFile = Join-Path $DbDir '.env'
$envVars = Import-DotEnv -Path $envFile

$Stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$OutFile = Join-Path $BackupDir "lang_uoc_le_$Stamp.sql.gz"

Push-Location $DbDir
try {
    # docker compose exec ghi dump ra stdout dạng SQL text; nén bằng gzip qua .NET
    # vì Windows không có sẵn lệnh gzip.
    $sql = docker compose exec -T postgres pg_dump -U $envVars['POSTGRES_USER'] -d $envVars['POSTGRES_DB']
    if ($LASTEXITCODE -ne 0) {
        Write-Error "pg_dump thất bại."
        exit 1
    }

    $bytes = [System.Text.Encoding]::UTF8.GetBytes(($sql -join "`n"))
    $fileStream = [System.IO.File]::Create($OutFile)
    $gzipStream = New-Object System.IO.Compression.GzipStream($fileStream, [System.IO.Compression.CompressionMode]::Compress)
    try {
        $gzipStream.Write($bytes, 0, $bytes.Length)
    } finally {
        $gzipStream.Dispose()
        $fileStream.Dispose()
    }

    Write-Host "Đã backup: $OutFile"
} finally {
    Pop-Location
}
