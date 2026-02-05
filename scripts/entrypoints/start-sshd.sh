#!/usr/bin/env bash
set -euo pipefail

ROOT_PASSWORD="${ROOT_PASSWORD:-toor}"
QWE_PASSWORD="${QWE_PASSWORD:-toor}"
QWE_UID="${QWE_UID:-1000}"
QWE_GID="${QWE_GID:-1000}"

if ! getent group qwe >/dev/null 2>&1; then
  groupadd -g "$QWE_GID" qwe
fi

if ! id qwe >/dev/null 2>&1; then
  useradd -m -d /config -s /bin/zsh -u "$QWE_UID" -g "$QWE_GID" qwe
fi

echo "root:${ROOT_PASSWORD}" | chpasswd
echo "qwe:${QWE_PASSWORD}" | chpasswd

mkdir -p /run/sshd /config
chown -R qwe:qwe /config

if [[ "${ENABLE_SUDO_NOPASSWD:-1}" == "1" ]]; then
  echo "qwe ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/qwe
  chmod 0440 /etc/sudoers.d/qwe
fi

exec /usr/sbin/sshd -D -e
