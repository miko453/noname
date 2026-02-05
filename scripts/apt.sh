#!/usr/bin/env bash
set -euo pipefail

DEFAULT_MIRROR="http://http.kali.org/kali"
TARGET_MIRROR="${APT_MIRROR:-$DEFAULT_MIRROR}"
SOURCES_FILE="/etc/apt/sources.list"
BACKUP_FILE="/etc/apt/sources.list.bak"

write_sources() {
  local mirror="$1"
  cat > "$SOURCES_FILE" <<EOL
deb ${mirror} kali-rolling main non-free contrib non-free-firmware
EOL
}

switch_sources() {
  echo "[apt.sh] switching APT mirror to: ${TARGET_MIRROR}"

  if [[ -f "$SOURCES_FILE" && ! -f "$BACKUP_FILE" ]]; then
    cp "$SOURCES_FILE" "$BACKUP_FILE"
  fi

  write_sources "$TARGET_MIRROR"

  if ! apt-get update; then
    echo "[apt.sh] mirror unavailable, rolling back to original sources"
    restore_sources
    apt-get update
  fi
}

restore_sources() {
  echo "[apt.sh] restoring APT sources"
  if [[ -f "$BACKUP_FILE" ]]; then
    mv "$BACKUP_FILE" "$SOURCES_FILE"
  else
    write_sources "$DEFAULT_MIRROR"
  fi
}

case "${1:-}" in
  switch)
    switch_sources
    ;;
  restore)
    restore_sources
    ;;
  *)
    echo "Usage: $0 {switch|restore}" >&2
    exit 1
    ;;
esac
