#!/usr/bin/env bash
# Chuẩn bị dữ liệu định tuyến OSRM (đi bộ) cho làng Ước Lễ — chạy 1 lần.
# Chạy từ bất kỳ đâu: bash map-tour/routing/build.sh
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DATA_DIR="$SCRIPT_DIR/data"
mkdir -p "$DATA_DIR"

VIETNAM_PBF="$DATA_DIR/vietnam-latest.osm.pbf"
CLIPPED_PBF="$DATA_DIR/uoc-le.osm.pbf"
OSRM_FILE="$DATA_DIR/uoc-le.osrm"

# Vùng bao quanh làng Ước Lễ (Thanh Oai, Hà Nội) + biên an toàn ~1.5km,
# đủ để OSRM đi qua các đường/ngõ thật quanh làng mà không phải xử lý
# toàn bộ dữ liệu OSM Việt Nam.
BBOX='105.794,20.809,105.828,20.843'

if [ ! -f "$VIETNAM_PBF" ]; then
  echo "Đang tải dữ liệu OSM Việt Nam từ Geofabrik..."
  curl -L -o "$VIETNAM_PBF" 'https://download.geofabrik.de/asia/vietnam-latest.osm.pbf'
fi

if [ ! -f "$CLIPPED_PBF" ]; then
  echo "Đang cắt vùng làng Ước Lễ ($BBOX)..."
  docker run --rm -v "$DATA_DIR:/data" ubuntu:24.04 bash -c \
    "apt-get update -qq && apt-get install -y -qq osmium-tool && osmium extract -b $BBOX /data/vietnam-latest.osm.pbf -o /data/uoc-le.osm.pbf --overwrite"
fi

if [ ! -f "$OSRM_FILE" ]; then
  echo "Đang xử lý OSRM (profile đi bộ, thuật toán MLD)..."
  docker run --rm -v "$DATA_DIR:/data" osrm/osrm-backend osrm-extract -p /opt/foot.lua /data/uoc-le.osm.pbf
  docker run --rm -v "$DATA_DIR:/data" osrm/osrm-backend osrm-partition /data/uoc-le.osrm
  docker run --rm -v "$DATA_DIR:/data" osrm/osrm-backend osrm-customize /data/uoc-le.osrm
fi

echo "Xong. Chạy 'docker compose up -d osrm' để bật dịch vụ định tuyến."
