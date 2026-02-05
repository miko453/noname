#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# 新值可通过环境变量覆盖
NOMACHINE_URL_NEW="${NOMACHINE_URL_NEW:-https://web9001.nomachine.com/download/9.3/Linux/nomachine_9.3.7_1_amd64.deb}"
ANYDESK_URL_NEW="${ANYDESK_URL_NEW:-https://download.anydesk.com/linux/anydesk_7.1.3-1_amd64.deb}"
CHROME_URL_NEW="${CHROME_URL_NEW:-https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb}"
REALVNC_URL_NEW="${REALVNC_URL_NEW:-https://downloads.realvnc.com/download/file/viewer.files/VNC-Viewer-7.11.0-Linux-x64.deb}"
APT_MIRROR_NEW="${APT_MIRROR_NEW:-http://mirrors.7.b.0.5.0.7.4.0.1.0.0.2.ip6.arpa/system/kali}"
DEBIAN_MIRROR_NEW="${DEBIAN_MIRROR_NEW:-http://mirrors.7.b.0.5.0.7.4.0.1.0.0.2.ip6.arpa/system/debian}"

replace_literal() {
  local old="$1"
  local new="$2"
  rg -l --hidden -g '!.git/*' --fixed-strings "$old" "$ROOT_DIR" 2>/dev/null | while IFS= read -r file; do
        sed -i "s|${old//|/\\|}|${new//|/\\|}|g" "$file"
        echo "[updated] $file"
      done || true
}

echo "[info] replacing third-party URLs and mirror args in: $ROOT_DIR"

replace_literal "https://web9001.nomachine.com/download/9.3/Linux/nomachine_9.3.7_1_amd64.deb" "$NOMACHINE_URL_NEW"
replace_literal "https://download.anydesk.com/linux/anydesk_7.1.3-1_amd64.deb" "$ANYDESK_URL_NEW"
replace_literal "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb" "$CHROME_URL_NEW"
replace_literal "https://downloads.realvnc.com/download/file/viewer.files/VNC-Viewer-7.11.0-Linux-x64.deb" "$REALVNC_URL_NEW"
replace_literal "APT_MIRROR ?= http://mirrors.7.b.0.5.0.7.4.0.1.0.0.2.ip6.arpa/system/kali" "APT_MIRROR ?= $APT_MIRROR_NEW"
replace_literal "DEBIAN_MIRROR ?= http://mirrors.7.b.0.5.0.7.4.0.1.0.0.2.ip6.arpa/system/debian" "DEBIAN_MIRROR ?= $DEBIAN_MIRROR_NEW"

echo "[done] replace finished"
