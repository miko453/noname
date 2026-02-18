# 🗺️ NONAME - 无特权云工作站完整蓝图

## 📋 文档目录

### 1. 项目概述
- **1.1 项目信息**
- **1.2 宿主机适配**
- **1.3 无特权运行**
- **1.4 数据持久化**
- **1.5 用户管理**
- **1.6 安装机制**
- **1.7 Docker Hub 管理**
- **1.8 远程访问**
- **1.9 匿名化上网**

### 2. 集群镜像功能模块
- **2.1 基础工具与自动化（Alpine 系列）**
- **2.2 平台专用镜像**
- **2.3 日用桌面模板（Debian Unstable / Kali Rolling）**
- **2.4 多媒体工作站**
- **2.5 隐私通信与匿名上网工具**
- **2.6 控制台与集群管理**

### 3. 技术规范
- **3.1 进程管理**
- **3.2 功能开关控制原理**
- **3.3 环境变量配置**
- **3.4 软件源配置**
- **3.5 镜像构建优化**
- **3.6 本地化支持**
- **3.7 功能模块化管理**
- **3.8 Shell 环境统一**
- **3.9 默认配置参数**

### 4. 核心亮点
- **4.1 统一集群管理**
- **4.2 无特权架构**
- **4.3 动态安装机制**
- **4.4 全栈远程访问**
- **4.5 功能开关控制**
- **4.6 自动资源维护**
- **4.7 标准化认证**
- **4.8 极致轻量化**
- **4.9 多媒体工作站**
- **4.10 匿名化上网**
- **4.11 环境一致性**

### 5. 匿名化上网方案
- **5.1 V2RayA 详解**

### 6. 镜像尺寸汇总

## 📋 核心设计原则

### 1. 项目信息
- **项目名称**：NONAME
- **GitHub 仓库**：https://github.com/miko453/noname
- **定位**：无特权云工作站完整解决方案

### 2. 宿主机适配
- 基于 Alpine Linux 构建
- 支持 IPv6-only 网络环境
- 适配极低配 VPS（1c1g10g）

### 3. 无特权运行
- 所有容器支持非特权运行（fallback）
- 统一使用 dropbear 作为 SSH 服务

### 4. 数据持久化
- 统一挂载 `/config` 目录用于数据持久化

### 5. 用户管理
- 普通用户：`qwe:toor`（配置 sudo 权限）
- root 用户：`root:toor`
- 默认密码：root/toor, qwe/toor

### 6. 安装机制
- 使用外部安装脚本：`scripts/install-*.sh`
- Dockerfile 仅负责基础环境，不直接写入安装命令

### 7. Docker Hub 管理
- builder-alpine + WebConsole 自动清理旧镜像
- 支持删除仓库所有镜像（包括未打标签的）

### 8. 远程访问
- **noVNC**：支持音频传输
- **xrdp**：支持 XFCE4 桌面
- **Kali Full**：支持 Anydesk / NoMachine / Google Chrome

### 9. 匿名化上网
- **alpine-v2raya-lite**：支持 VMess/VLESS/Trojan/Shadowsocks 等多协议，提供 WebUI 管理
- **alpine-tor-browser**：独立容器运行，高匿名上网，支持 .onion 网站访问
- **alpine-privacy-comm**：独立容器运行，综合隐私通信套件（Pidgin + HexChat），支持 OTR 加密和 SSL/TLS 连接
- **纯 IPv6 环境优化**：解决 IPv6-only 网络访问限制
- **可选全局/分流代理**：灵活配置上网策略
- **容器隔离安全**：所有隐私上网工具均以独立 Alpine 容器运行，防止被黑影响其他服务

---

## 🖥️ 集群镜像功能模块

### 1. 基础工具与自动化（Alpine 系列）

#### alpine-base (~50MB)
- openssl, curl, wget, openssh, ca-certificates, tzdata
- supervisord 作为 init 进程

#### alpine-chromium (~150MB) ⭐
- Chromium 浏览器 + VNC 服务
- 轻量级远程浏览解决方案

#### alpine-v2raya-lite (~80MB) ⭐
- V2RayA 代理服务 + WebUI 管理
- 支持 VMess/VLESS/Trojan/Shadowsocks 等协议
- 解决纯 IPv6 环境网络访问问题
- 可选全局代理或规则分流

#### alpine-devcontainer (~300–400MB) ⭐
- Python, Go, Node.js 开发环境
- 适用于 CI、本地调试、GitHub Codespaces

#### alpine-builder (~150MB) ⭐
- Docker, buildx, buildkit
- Docker Hub 构建/推送/清理工具

#### alpine-qemu-tools (~200MB) ⭐
- qemu-system, qemu-img 基础工具

---

### 2. 平台专用镜像

#### deepnote-py313 (~300MB) ⭐
- Python 3.13 环境
- Deepnote 平台专用镜像
- 包含 bash, curl 及 XFCE4, Terminator, Google Chrome, RealVNC Viewer

#### debian11-xfce4-tightvnc (~400–500MB) ⭐
- 最小化 XFCE4 + tightvncserver
- 远程终端操作
- 必装 asbru-cm

---

### 3. 日用桌面模板（Debian Unstable / Kali Rolling）

#### debian-unstable-xfce4 ⭐
- XFCE4 桌面环境
- Google Chrome
- RealVNC Viewer
- Terminator 终端

#### debian-unstable-icewm ⭐
- IceWM 桌面环境（轻量级）
- Google Chrome
- RealVNC Viewer
- Terminator 终端

#### kali-rolling-xfce4 ⭐
- XFCE4 桌面环境
- Google Chrome
- RealVNC Viewer
- Terminator 终端

#### kali-rolling-icewm ⭐
- IceWM 桌面环境（轻量级）
- Google Chrome
- RealVNC Viewer
- Terminator 终端

#### kali-full-xfce4
- XFCE4 桌面环境
- Anydesk / NoMachine / Google Chrome
- noVNC + 音频支持
- xrdp 服务

#### kali-full-icewm
- IceWM 桌面环境（轻量级）
- Anydesk / NoMachine / Google Chrome
- noVNC + 音频支持
- xrdp 服务

---

### 4. 多媒体工作站

#### media-synthv-studio (~600MB) ⭐
- **歌声合成软件**：
  - Synthesizer V Studio（核心应用）
  - 常用歌声合成库和工具集
- **音视频处理套件**：
  - OBS Studio（直播/录制）
  - VLC Player（多媒体播放）
  - ffmpeg（音视频转换/处理）
  - rosegarden（MIDI 编辑与作曲）
- **远程访问支持**：
  - Anydesk / NoMachine 完整功能
  - xrdp 服务（含音频同步）
  - noVNC + 音频传输
- 基于 Debian/Kali 构建
- 预装歌声合成所需常用依赖库

---

### 5. 隐私通信与匿名上网工具

#### alpine-tor-browser (~200MB) ⭐
- **Tor 匿名网络**：
  - Tor 客户端 + 代理服务
  - 支持 .onion 网站访问
  - 自动路由通过 Tor 网络
- **安全浏览**：
  - 隔离网络连接
  - 防止 DNS 泄漏
  - 加密多层转发
- **适用场景**：
  - 高匿名上网需求
  - 访问暗网资源
  - 隐私敏感操作
- **无特权支持**：支持非特权运行（fallback），dropbear SSH + /config 持久化

#### alpine-privacy-comm (~150MB) ⭐
- **综合隐私通信套件**：
  - Pidgin：多协议即时通讯（XMPP/Jabber、IRC、AIM、ICQ、MSN 等）
  - HexChat：现代 IRC 客户端
- **安全特性**：
  - 支持 OTR 端到端加密
  - SSL/TLS 加密连接
  - 可通过 Tor 代理连接
  - 身份信息最小化
- **核心功能**：
  - 多账户管理
  - 插件化架构，可扩展性强
  - 多个 IRC 网络同时连接
  - 文件传输（DCC）
  - 频道管理与脚本自动化
- **隐私保护**：
  - 配合 Tor 使用增强隐私
  - 防止 DNS 泄漏
  - 日志记录与加密
- **无特权支持**：支持非特权运行（fallback），dropbear SSH + /config 持久化

---

### 6. 控制台与集群管理

#### web-console-nextjs ⭐
- 基于 Node.js + Next.js
- 功能开关式集群管理：
  - 启用/禁用桌面模板
  - 启用/禁用开发工具
  - 启用/禁用构建/推送
  - 启用/禁用 QEMU 工具
  - 启用/禁用 V2RayA 代理服务
  - 启用/禁用 Tor 服务
  - 启用/禁用隐私通信工具
- 类似 Portainer.io 风格的 Web UI

---

## ⚙️ 技术规范

### 进程管理
- 使用 supervisord 作为 init 进程
- 轻量级多进程管理方案

### 功能开关控制原理

#### 容器级开关
- **WebConsole API 控制**：通过 RESTful API 发送启动/停止命令给 Docker Engine
- **Docker 容器生命周期**：
  - `docker start/stop <container>` 控制运行状态
  - 持久化数据保留在 `/config` 卷中
  - 停止容器时应用进程终止，但数据不丢失
- **状态同步**：WebConsole 实时查询 `docker ps` 获取容器状态

#### 应用级开关（容器内）
- **环境变量注入**：通过 `docker update --env` 动态修改容器环境变量
- **进程热重载**：应用监听环境变化（如 SIGHUP 信号）实现配置热更新
- **Supervisor 控制**：通过 `supervisorctl` 启动/停止特定进程组
- **配置文件重载**：应用检测到配置变化后自动重新加载

#### 实现架构
```
WebConsole 前端 → REST API → WebConsole 后端 → Docker Engine
                                          → 容器内 Supervisor → 应用进程
```

#### 技术细节
- **状态存储**：容器开关状态记录在 WebConsole 数据库
- **即时生效**：大部分开关操作立即生效，无需重启容器
- **故障恢复**：容器意外退出时，根据上次开关状态决定是否自动重启
- **权限验证**：WebConsole 操作需身份认证，防止未授权访问

#### 配置示例
```bash
# 通过环境变量控制 V2RayA
ENABLE_V2RAYA=true
V2RAYA_PROTOCOL=vmess

# 通过 Supervisor 进程组控制
supervisorctl start v2raya
supervisorctl stop v2raya
```

### 环境变量配置

| 类别 | 环境变量 |
|------|----------|
| 基础配置 | LANG, TZ, DEBUG |
| SSH 相关 | ENABLE_SSH, SSH_PORT, ALLOW_PASSWORD |
| VNC 相关 | ENABLE_VNC, VNC_GEOMETRY, VNC_DEPTH, VNC_PASSWORD |
| V2RayA 相关 | ENABLE_V2RAYA, V2RAYA_PROTOCOL, V2RAYA_ADMIN_PORT |
| 应用特定 | 各镜像自定义 |

### 软件源配置
- 通过 apt.sh 脚本实现构建时换源
- 默认镜像源：http://mirrors.7.b.0.5.0.7.4.0.1.0.0.2.ip6.arpa/system/debian或kali或Alpine
- 支持 Kali/Debian/Alpine 三种发行版
- 适配 IPv6-only 网络环境

### 镜像构建优化
- 使用 RUN 链式命令减少层级
- 完成 apt 清理（删除缓存、自动安装推荐包）
- 移除不必要的文档和 man 手册
- 支持动态加载功能模块

### 本地化支持
- 默认英文环境
- 需确保中文字体正常显示

### 功能模块化管理
- 将安装脚本内置到容器中
- 用户可通过 WebConsole 启用/禁用功能模块
- 类似 Windows 功能开关的设计理念

### Shell 环境统一
- 所有镜像（Kali 除外）使用统一的 `/etc/skel` 模板
- Kali 系统保留原生 shell 配置
- 确保跨发行版用户环境的一致性体验

### 默认配置参数

| 配置项 | 默认值 |
|--------|--------|
| VNC 密码 | 114514 |
| VNC 分辨率 | 1920×1200×24 |
| Kali 默认 Shell | zsh |
| Kali 安全设置 | RA2_256 |
| V2RayA 管理端口 | 2017 |
| V2RayA WebUI 端口 | 8883 |

---

## 🎯 核心亮点

1. **统一集群管理**：通过 WebConsole 实现对所有镜像实例的集中管控
2. **无特权架构**：dropbear SSH 服务 + `/config` 持久化目录，提供安全的容器环境
3. **动态安装机制**：外部 install-*.sh 脚本，适应不同配置和资源限制
4. **全栈远程访问**：noVNC 音频 / xrdp / Anydesk / NoMachine 全面支持
5. **功能开关控制**：WebConsole 提供类似 Windows 功能的模块化管理界面
6. **自动资源维护**：Docker Hub 镜像自动清理，保持注册表整洁
7. **标准化认证**：统一的用户体系和 sudo 权限配置
8. **极致轻量化**：基础镜像 <100MB，工作站 <1.5GB，全集 <10GB
9. **多媒体工作站**：集成 Synthesizer V Studio 等歌声合成软件，支持全栈远程访问
10. **匿名化上网**：内置 V2RayA 代理服务，支持多协议，适配 IPv6-only 环境
11. **环境一致性**：统一 skel 文件夹，确保跨发行版用户环境一致（Kali 除外）

---

## 🔒 匿名化上网方案

### V2RayA 详解

#### 功能特性
- **多协议支持**：VMess, VLESS, Trojan, Shadowsocks, SOCKS 等
- **WebUI 管理**：基于 Web 的直观配置界面
- **透明代理**：支持 iptables/nftables 透明代理
- **规则路由**：支持域名/IP/GeoIP 规则分流
- **负载均衡**：多服务器负载均衡和故障转移

#### 配置方式
1. **WebConsole 控制**：通过集群管理界面一键启用/禁用
2. **环境变量配置**：
   ```bash
   ENABLE_V2RAYA=true
   V2RAYA_PROTOCOL=vmess
   V2VPN_ADMIN_PORT=2017
   ```
3. **外部配置导入**：支持订阅链接一键导入节点配置

#### 应用场景
- **突破网络限制**：访问受地域限制的内容
- **隐私保护**：加密传输，隐藏真实 IP
- **IPv6 环境适配**：解决纯 IPv6 VPS 访问 Internet 的问题
- **科学上网**：支持主流机场协议

#### 注意事项
- 遵守当地法律法规，合法使用代理服务
- 定期更新 V2RayA 版本以获取最新特性
- 妥善保管服务器节点配置信息
- 建议配合防火墙规则增强安全性

---

## 📦 镜像尺寸汇总

| 镜像名称 | 约大小 | 主要用途 |
|---------|--------|---------|
| alpine-base | 50MB | 基础 Alpine 环境 |
| alpine-chromium | 150MB | 轻量浏览 |
| alpine-v2raya-lite | 80MB | 代理服务 |
| alpine-devcontainer | 300–400MB | 开发环境 |
| alpine-builder | 150MB | Docker 构建 |
| alpine-qemu-tools | 200MB | 虚拟化工具 |
| deepnote-py313 | 300MB | Python 开发 |
| debian11-xfce4-tightvnc | 400–500MB | 远程终端 |
| debian/unstable/kali (XFCE4/IceWM) | 500–700MB | 桌面办公 |
| kali-full (XFCE4/IceWM) | 800–1000MB | 全功能桌面 |
| media-synthv-studio | ~600MB | 歌声合成 |
| web-console-nextjs | 200–300MB | 集群管理 |

**全集估算**：约 8–10GB（包含所有镜像和依赖）
