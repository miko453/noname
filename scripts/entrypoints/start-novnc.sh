#!/usr/bin/env bash
set -euo pipefail

NOVNC_PORT="${NOVNC_PORT:-6001}"
VNC_TARGET_HOST="${VNC_TARGET_HOST:-127.0.0.1}"
VNC_TARGET_PORT="${VNC_TARGET_PORT:-5901}"
NOVNC_WEB="${NOVNC_WEB:-/usr/share/novnc}"

if [[ "${ENABLE_NOMACHINE:-0}" == "1" ]] && [[ -x /usr/NX/bin/nxserver ]]; then
  /usr/NX/bin/nxserver --startup || true
fi

/app/start-vnc.sh &
VNC_PID=$!

trap 'kill ${VNC_PID} 2>/dev/null || true' EXIT

exec /usr/share/novnc/utils/novnc_proxy --vnc "${VNC_TARGET_HOST}:${VNC_TARGET_PORT}" --listen "${NOVNC_PORT}" --web "${NOVNC_WEB}"
