ARG BASE_IMAGE=noname:ssh-base
FROM ${BASE_IMAGE}

ENV DEBIAN_FRONTEND=noninteractive \
    VNC_PASSWORD=114514 \
    DESKTOP_CMD=/usr/bin/openbox-session

COPY scripts/chrome-wrapper.sh /usr/local/bin/chrome
COPY scripts/entrypoints/start-vnc.sh /app/start-vnc.sh

RUN chmod +x /usr/local/bin/chrome /app/start-vnc.sh && \
    /usr/local/bin/apt.sh switch && \
    apt-get install -y --no-install-recommends \
      openbox obconf terminator \
      tigervnc-standalone-server tigervnc-tools \
      fonts-wqy-zenhei fonts-noto-cjk fonts-noto-color-emoji \
      libgssapi-krb5-2 libssl3 xdg-utils && \
    wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    apt-get install -y --no-install-recommends ./google-chrome-stable_current_amd64.deb && \
    rm -f google-chrome-stable_current_amd64.deb && \
    wget -q https://downloads.realvnc.com/download/file/viewer.files/VNC-Viewer-7.11.0-Linux-x64.deb && \
    apt-get install -y --no-install-recommends ./VNC-Viewer-7.11.0-Linux-x64.deb && \
    rm -f VNC-Viewer-7.11.0-Linux-x64.deb && \
    /usr/local/bin/apt.sh restore && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 5901
CMD ["/app/start-vnc.sh"]
