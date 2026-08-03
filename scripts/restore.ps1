# Restore CSDL từ 1 file backup .sql.gz (Windows).
# Chạy: pwsh scripts/restore.ps1 backups\lang_uoc_le_20260101-120000.sql.gz
# CẢNH BÁO: lệnh này ghi đè toàn bộ dữ liệu hiện có trong DB đích.
param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$BackupFile
)
$ErrorActionPreference = 'Stop'

if (-not (Test-Path $BackupFile)) {
    Write-Error "Không tìm thấy file: $BackupFile"
    exit 1
}

$DbDir = Split-Path -Parent $PSScriptRoot
. "$PSScriptRoot\_env.ps1"

$envFile = Join-Path $DbDir '.env'
$envVars = Import-DotEnv -Path $envFile

$confirm = Read-Host "Ghi đè toàn bộ dữ liệu trong DB '$($envVars['POSTGRES_DB'])'? Nhập 'yes' để tiếp tục"
if ($confirm -ne 'yes') {
    Write-Host "Đã hủy."
    exit 1
}

Push-Location $DbDir
try {
    $fileStream = [System.IO.File]::OpenRead((Resolve-Path $BackupFile))
    $gzipStream = New-Object System.IO.Compression.GzipStream($fileStream, [System.IO.Compression.CompressionMode]::Decompress)
    $reader = New-Object System.IO.StreamReader($gzipStream, [System.Text.Encoding]::UTF8)
    try {
        $sql = $reader.ReadToEnd()
    } finally {
        $reader.Dispose()
        $gzipStream.Dispose()
        $fileStream.Dispose()
    }

    $sql | docker compose exec -T postgres psql -U $envVars['POSTGRES_USER'] -d $envVars['POSTGRES_DB']
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Restore thất bại."
        exit 1
    }

    Write-Host "Đã restore từ: $BackupFile"
} finally {
    Pop-Location
}
