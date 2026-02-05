#!/usr/bin/env bash
set -euo pipefail

if [[ "${ENABLE_NOMACHINE:-0}" == "1" ]]; then
  if command -v /usr/NX/bin/nxserver >/dev/null 2>&1; then
    /usr/NX/bin/nxserver --startup || true
  else
    echo "[start-workstation] ENABLE_NOMACHINE=1 but NoMachine not installed."
  fi
fi

exec /app/start-vnc.sh
