# Đọc file .env ở gốc project và trả về hashtable KEY=VALUE.
# Dùng chung bởi các script .ps1 khác trong thư mục này — không chạy trực tiếp.

function Import-DotEnv {
    param(
        [Parameter(Mandatory = $true)][string]$Path
    )

    if (-not (Test-Path $Path)) {
        Write-Error "Không thấy $Path — copy từ .env.example và đổi mật khẩu trước.`n  Copy-Item .env.example .env"
        exit 1
    }

    $envVars = @{}
    foreach ($line in Get-Content $Path) {
        $trimmed = $line.Trim()
        if ($trimmed -eq '' -or $trimmed.StartsWith('#')) { continue }
        $idx = $trimmed.IndexOf('=')
        if ($idx -lt 1) { continue }
        $key = $trimmed.Substring(0, $idx).Trim()
        $value = $trimmed.Substring($idx + 1).Trim()
        $envVars[$key] = $value
    }
    return $envVars
}
