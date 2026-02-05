#!/usr/bin/env bash
set -euo pipefail

DEFAULT_MIRROR="http://mirrors.7.b.0.5.0.7.4.0.1.0.0.2.ip6.arpa/system/debian"
TARGET_MIRROR="${APT_MIRROR:-$DEFAULT_MIRROR}"
SOURCES_FILE="/etc/apt/sources.list"
BACKUP_FILE="/etc/apt/sources.list.bak"

write_sources() {
  local mirror="$1"
  cat > "$SOURCES_FILE" <<EOL
deb ${mirror} bullseye main contrib non-free
EOL
}

switch_sources() {
  if [[ -f "$SOURCES_FILE" && ! -f "$BACKUP_FILE" ]]; then
    cp "$SOURCES_FILE" "$BACKUP_FILE"
  fi
  write_sources "$TARGET_MIRROR"
  if ! apt-get update; then
    restore_sources
    apt-get update
  fi
}

restore_sources() {
  if [[ -f "$BACKUP_FILE" ]]; then
    mv "$BACKUP_FILE" "$SOURCES_FILE"
  else
    write_sources "$DEFAULT_MIRROR"
  fi
}

case "${1:-}" in
  switch) switch_sources ;;
  restore) restore_sources ;;
  *) echo "Usage: $0 {switch|restore}"; exit 1 ;;
esac
