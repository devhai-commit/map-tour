# Chuẩn bị dữ liệu định tuyến OSRM (đi bộ) cho làng Ước Lễ — chạy 1 lần.
# Chạy: pwsh map-tour/routing/build.ps1  (hoặc .\map-tour\routing\build.ps1 trong PowerShell)
$ErrorActionPreference = 'Stop'

$RoutingDir = $PSScriptRoot
$DataDir = Join-Path $RoutingDir 'data'
New-Item -ItemType Directory -Force -Path $DataDir | Out-Null

$VietnamPbf = Join-Path $DataDir 'vietnam-latest.osm.pbf'
$ClippedPbf = Join-Path $DataDir 'uoc-le.osm.pbf'
$OsrmFile = Join-Path $DataDir 'uoc-le.osrm'

# Vùng bao quanh làng Ước Lễ (Thanh Oai, Hà Nội) + biên an toàn ~1.5km,
# đủ để OSRM đi qua các đường/ngõ thật quanh làng mà không phải xử lý
# toàn bộ dữ liệu OSM Việt Nam.
$Bbox = '105.794,20.809,105.828,20.843'

if (-not (Test-Path $VietnamPbf)) {
    Write-Host 'Đang tải dữ liệu OSM Việt Nam từ Geofabrik...'
    Invoke-WebRequest -Uri 'https://download.geofabrik.de/asia/vietnam-latest.osm.pbf' -OutFile $VietnamPbf
}

if (-not (Test-Path $ClippedPbf)) {
    Write-Host "Đang cắt vùng làng Ước Lễ ($Bbox)..."
    docker run --rm -v "${DataDir}:/data" ubuntu:24.04 bash -c `
        "apt-get update -qq && apt-get install -y -qq osmium-tool && osmium extract -b $Bbox /data/vietnam-latest.osm.pbf -o /data/uoc-le.osm.pbf --overwrite"
    if ($LASTEXITCODE -ne 0) { throw 'Cắt vùng OSM thất bại (osmium extract).' }
}

if (-not (Test-Path $OsrmFile)) {
    Write-Host 'Đang xử lý OSRM (profile đi bộ, thuật toán MLD)...'
    docker run --rm -v "${DataDir}:/data" osrm/osrm-backend osrm-extract -p /opt/foot.lua /data/uoc-le.osm.pbf
    if ($LASTEXITCODE -ne 0) { throw 'osrm-extract thất bại.' }
    docker run --rm -v "${DataDir}:/data" osrm/osrm-backend osrm-partition /data/uoc-le.osrm
    if ($LASTEXITCODE -ne 0) { throw 'osrm-partition thất bại.' }
    docker run --rm -v "${DataDir}:/data" osrm/osrm-backend osrm-customize /data/uoc-le.osrm
    if ($LASTEXITCODE -ne 0) { throw 'osrm-customize thất bại.' }
}

Write-Host "Xong. Chạy 'docker compose up -d osrm' để bật dịch vụ định tuyến."
