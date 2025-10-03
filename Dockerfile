# 使用 Kali Linux 最新版本作为基础镜像
FROM kalilinux/kali-last-release

# 设置构建参数用于 VNC 密码
ARG VNC_PASSWORD=114514

# 设置环境变量以避免交互式提示
ENV DEBIAN_FRONTEND=noninteractive \
    USER=qwe \
    HOME=/config

# 更新包列表并安装基础工具
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    systemd \
    systemd-sysv \
    dbus \
    dbus-user-session \
    openssh-client \
    curl \
    wget \
    unzip \
    htop \
    iputils-ping \
    net-tools \
    iproute2 \
    psmisc \
    sudo \
    vim \
    ca-certificates \
    dbus-x11 \
    zsh \
    zsh-common \
    zsh-syntax-highlighting \
    zsh-autosuggestions \
    && rm -rf /var/lib/apt/lists/*

# 创建用户qwe，设置home目录为/config，并添加到sudo组
RUN useradd -m -d /config -s /bin/zsh qwe && \
    usermod -aG sudo qwe && \
    echo "qwe ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    chown -R qwe:qwe /config

# 安装桌面环境和必要组件
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    xfce4 \
    xfce4-goodies \
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

# 创建 VNC 配置初始化脚本
RUN echo '#!/bin/zsh\n\
# 检查并复制 VNC 配置\n\
if [ ! -d "/config/.config/tigervnc" ]; then\n\
    mkdir -p /config/.config/tigervnc\n\
    cp -r /root/.config/tigervnc/* /config/.config/tigervnc/\n\
fi\n\
\n\
# 确保权限正确\n\
chown -R qwe:qwe /config/.config/tigervnc\n\
chmod 600 /config/.config/tigervnc/passwd\n\
\n\
vncserver :1 -SecurityTypes=RA2_256 -localhost=no -fg' > /usr/local/bin/init-vnc && \
    chmod +x /usr/local/bin/init-vnc

# 创建 systemd 服务文件
RUN echo '[Unit]\n\
Description=VNC Server for XFCE Desktop\n\
After=syslog.target network.target\n\
\n\
[Service]\n\
Type=simple\n\
User=qwe\n\
Group=qwe\n\
ExecStart=/usr/local/bin/init-vnc\n\
Restart=on-failure\n\
RestartSec=5\n\
\n\
[Install]\n\
WantedBy=multi-user.target\n' > /etc/systemd/system/vncserver.service && \
    systemctl enable vncserver.service

# 清理缓存和临时文件以减少镜像大小
RUN apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/* /tmp/* /var/tmp/* ~/.cache/*

# 设置容器启动时执行的命令
CMD ["/sbin/init"]

