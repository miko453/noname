FROM ghcr.io/miko453/kali-base

# 默认VNC密码给你变成114514
ENV VNC_PASSWORD=114514

# 安装桌面环境和必要组件
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    kali-desktop-xfce \
    tigervnc-standalone-server \
    tigervnc-tools \
    fonts-wqy-zenhei \
    fonts-noto-cjk \
    fonts-noto-color-emoji \
    terminator \
    && rm -rf /var/lib/apt/lists/* 

# 下载并安装 Google Chrome
RUN wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    apt-get update && \
    apt-get install -y --no-install-recommends ./google-chrome-stable_current_amd64.deb && \
    rm -f google-chrome-stable_current_amd64.deb && \
    rm -rf /var/lib/apt/lists/*

# 下载并安装 RealVNC Viewer
RUN wget -q https://downloads.realvnc.com/download/file/viewer.files/VNC-Viewer-7.11.0-Linux-x64.deb && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
    libgssapi-krb5-2 \
    libssl3 \
    ./VNC-Viewer-7.11.0-Linux-x64.deb && \
    rm -f VNC-Viewer-7.11.0-Linux-x64.deb && \
    rm -rf /var/lib/apt/lists/*

# 在 root 下设置 VNC 密码
RUN mkdir -p /root/.config/tigervnc && \
    echo "${VNC_PASSWORD}" | vncpasswd -f > /root/.config/tigervnc/passwd && \
    chmod 600 /root/.config/tigervnc/passwd
COPY init-vnc /usr/local/bin/
COPY vncserver.service /etc/systemd/system/

RUN chmod 6755 /usr/local/bin/init-vnc

# VNC设置自启动
RUN systemctl enable vncserver

# 清理缓存和临时文件以减少镜像大小
RUN apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/* /tmp/* /var/tmp/* ~/.cache/*

# 设置容器启动时执行的命令
CMD ["/sbin/init"]

