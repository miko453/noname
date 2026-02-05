#!/usr/bin/env bash
set -euo pipefail

RDP_PORT="${RDP_PORT:-3389}"

if command -v /usr/sbin/xrdp-sesman >/dev/null 2>&1; then
  /usr/sbin/xrdp-sesman --nodaemon &
fi

if command -v /usr/sbin/xrdp >/dev/null 2>&1; then
  /usr/sbin/xrdp --nodaemon --port "${RDP_PORT}" &
fi

exec /app/start-vnc.sh
