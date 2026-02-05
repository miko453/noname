#!/usr/bin/env bash
set -euo pipefail

MODE="${CHROME_SANDBOX_MODE:-auto}"

extra_args=()
case "$MODE" in
  disable)
    extra_args+=(--no-sandbox --disable-dev-shm-usage)
    ;;
  enforce)
    ;;
  auto)
    if ! unshare -U true >/dev/null 2>&1; then
      extra_args+=(--no-sandbox --disable-dev-shm-usage)
    fi
    ;;
  *)
    echo "Unsupported CHROME_SANDBOX_MODE=$MODE" >&2
    exit 1
    ;;
esac

exec /usr/bin/google-chrome-stable "${extra_args[@]}" "$@"
