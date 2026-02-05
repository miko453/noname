ARG BASE_IMAGE=noname:ssh-base
FROM ${BASE_IMAGE}

ENV DEBIAN_FRONTEND=noninteractive \
    VNC_PASSWORD=114514 \
    DESKTOP_CMD=/usr/bin/startxfce4

ARG NOMACHINE_DEB_URL=""

COPY scripts/chrome-wrapper.sh /usr/local/bin/chrome
COPY scripts/entrypoints/start-vnc.sh /app/start-vnc.sh
COPY scripts/entrypoints/start-workstation.sh /app/start-workstation.sh

RUN chmod +x /usr/local/bin/chrome /app/start-vnc.sh /app/start-workstation.sh && \
    /usr/local/bin/apt.sh switch && \
    apt-get install -y --no-install-recommends \
      kali-desktop-xfce xfce4-terminal terminator \
      tigervnc-standalone-server tigervnc-tools \
      fonts-wqy-zenhei fonts-noto-cjk fonts-noto-color-emoji \
      libgssapi-krb5-2 libssl3 pulseaudio xdg-utils && \
    wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    apt-get install -y --no-install-recommends ./google-chrome-stable_current_amd64.deb && \
    rm -f google-chrome-stable_current_amd64.deb && \
    wget -q https://downloads.realvnc.com/download/file/viewer.files/VNC-Viewer-7.11.0-Linux-x64.deb && \
    apt-get install -y --no-install-recommends ./VNC-Viewer-7.11.0-Linux-x64.deb && \
    rm -f VNC-Viewer-7.11.0-Linux-x64.deb && \
    if [ -n "$NOMACHINE_DEB_URL" ]; then wget -q "$NOMACHINE_DEB_URL" -O /tmp/nomachine.deb && apt-get install -y --no-install-recommends /tmp/nomachine.deb && rm -f /tmp/nomachine.deb; fi && \
    /usr/local/bin/apt.sh restore && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 5901 4000
CMD ["/app/start-workstation.sh"]
