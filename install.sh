#!/usr/bin/env bash
set -euo pipefail

APP_NAME="status-dashboard"
IMAGE_NAME="acme-status-dashboard"
CONTAINER_NAME="status-dashboard"
APP_PORT="${PORT:-5000}"
APP_VERSION="${VERSION:-1.0.0}"
APP_API_KEY="${API_KEY:-}"

if [[ "${EUID}" -ne 0 ]]; then
  echo "Error: please run this script as root or with sudo"
  exit 1
fi

if [[ -z "${APP_API_KEY}" ]]; then
  echo "Error: API_KEY is required"
  echo "Example: sudo API_KEY=letmein ./install.sh"
  exit 1
fi

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Install nginx configuration..."
cp "${REPO_DIR}/status-dashboard.conf" /etc/nginx/sites-available/status-dashboard.conf

ln -sf /etc/nginx/sites-available/status-dashboard.conf /etc/nginx/sites-enabled/status-dashboard.conf
rm -f /etc/nginx/sites-enabled/default

echo "Test nginx configuration..."
nginx -t

echo "Enable nginx..."
systemctl enable nginx
systemctl restart nginx

echo "Build Docker image..."
docker build -t "${IMAGE_NAME}" "${REPO_DIR}"

echo "Remove old container if it exists..."
docker stop "${CONTAINER_NAME}" 2>/dev/null || true
docker rm "${CONTAINER_NAME}" 2>/dev/null || true

echo "Start new container..."
docker run -d \
  --name "${CONTAINER_NAME}" \
  --restart unless-stopped \
  -e PORT="${APP_PORT}" \
  -e VERSION="${APP_VERSION}" \
  -e API_KEY="${APP_API_KEY}" \
  -p 127.0.0.1:5000:"${APP_PORT}" \
  "${IMAGE_NAME}"

echo "Success: status-dashboard is ready at http://localhost/"

