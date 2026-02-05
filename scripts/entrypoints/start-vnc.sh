#!/usr/bin/env bash
set -euo pipefail

VNC_PASSWORD="${VNC_PASSWORD:-114514}"
VNC_DISPLAY="${VNC_DISPLAY:-:1}"
VNC_GEOMETRY="${VNC_GEOMETRY:-1920x1080}"
VNC_DEPTH="${VNC_DEPTH:-24}"
VNC_LOCALHOST="${VNC_LOCALHOST:-no}"
DESKTOP_CMD="${DESKTOP_CMD:-/usr/bin/startxfce4}"
QWE_UID="${QWE_UID:-1000}"
QWE_GID="${QWE_GID:-1000}"

if ! getent group qwe >/dev/null 2>&1; then
  if getent group "${QWE_GID}" >/dev/null 2>&1; then
    groupadd qwe
  else
    groupadd -g "${QWE_GID}" qwe
  fi
fi

if ! id qwe >/dev/null 2>&1; then
  if getent passwd "${QWE_UID}" >/dev/null 2>&1; then
    useradd -m -d /config -s /bin/bash -g qwe qwe
  else
    useradd -m -d /config -s /bin/bash -u "${QWE_UID}" -g qwe qwe
  fi
fi

if [[ ! -x "${DESKTOP_CMD}" ]]; then
  DESKTOP_CMD="/usr/bin/xterm"
fi

if ! command -v vncserver >/dev/null 2>&1; then
  echo "[start-vnc] ERROR: vncserver not found in PATH" >&2
  exit 1
fi

mkdir -p /config/.vnc
chown -R qwe:qwe /config

if [[ ! -f /config/.vnc/passwd ]]; then
  echo "$VNC_PASSWORD" | vncpasswd -f > /config/.vnc/passwd
  chmod 600 /config/.vnc/passwd
  chown qwe:qwe /config/.vnc/passwd
fi

if [[ ! -f /config/.vnc/xstartup ]]; then
  cat > /config/.vnc/xstartup <<EOS
#!/usr/bin/env bash
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
${DESKTOP_CMD}
EOS
  chmod +x /config/.vnc/xstartup
  chown qwe:qwe /config/.vnc/xstartup
fi

export USER=qwe
export HOME=/config

exec su -s /bin/bash -c "vncserver ${VNC_DISPLAY} -geometry ${VNC_GEOMETRY} -depth ${VNC_DEPTH} -localhost ${VNC_LOCALHOST} -fg" qwe
