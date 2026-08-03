# Triển khai/khởi động lại CSDL Postgres bằng Docker Compose (Windows).
# Chạy: pwsh scripts/deploy.ps1  (hoặc .\scripts\deploy.ps1 trong PowerShell)
$ErrorActionPreference = 'Stop'

$DbDir = Split-Path -Parent $PSScriptRoot
. "$PSScriptRoot\_env.ps1"

$envFile = Join-Path $DbDir '.env'
$envVars = Import-DotEnv -Path $envFile

Push-Location $DbDir
try {
    docker compose --env-file .env pull postgres
    docker compose --env-file .env up -d postgres

    Write-Host "Đang chờ Postgres sẵn sàng..."
    $ready = $false
    for ($i = 0; $i -lt 30; $i++) {
        docker compose --env-file .env exec -T postgres pg_isready -U $envVars['POSTGRES_USER'] *> $null
        if ($LASTEXITCODE -eq 0) {
            $ready = $true
            break
        }
        Start-Sleep -Seconds 2
    }

    if ($ready) {
        Write-Host "Postgres đã sẵn sàng."
        docker compose --env-file .env ps
    } else {
        Write-Error "Postgres không sẵn sàng sau 60s — kiểm tra log: docker compose logs postgres"
        exit 1
    }
} finally {
    Pop-Location
}
