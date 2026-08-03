# Mở psql shell tương tác vào container Postgres đang chạy (Windows).
# Chạy: pwsh scripts/psql-shell.ps1
$ErrorActionPreference = 'Stop'

$DbDir = Split-Path -Parent $PSScriptRoot
. "$PSScriptRoot\_env.ps1"

$envFile = Join-Path $DbDir '.env'
$envVars = Import-DotEnv -Path $envFile

Push-Location $DbDir
try {
    docker compose exec postgres psql -U $envVars['POSTGRES_USER'] -d $envVars['POSTGRES_DB']
} finally {
    Pop-Location
}
