# headless 镜像矩阵

这个仓库用于构建并发布一套分层可复用的 Linux 远程桌面容器镜像，核心目标是：

- 统一基础环境（APT 镜像、SSH、常用工具）；
- 按功能分层（VNC / noVNC / RDP / 远程控制软件）；
- 让不同使用场景按需选择最小镜像；
- 在 CI 中按依赖关系并行构建，构建完立即推送。

## 镜像分支结构

```text
base (SSH only)
├─ lite (XFCE4 + VNC + Chrome + RealVNC Viewer + xfce4-screenshooter)
│  ├─ lite-novnc
│  ├─ lite-rdp
│  └─ lite-novnc-rdp
├─ xfull (复用 lite，把 xfce4 升级为 kali-desktop-xfce)
│  └─ xfull-remote (合并 noVNC + RDP)
├─ full (复用 xfull-remote：noVNC + NoMachine + PulseAudio + AnyDesk + RDP)
└─ icewm-thin (极简 IceWM + RealVNC Viewer，无 Chrome)
   ├─ icewm-thin-novnc
   └─ icewm-thin-rdp
```

## 目录说明

- `images/`：全部 Dockerfile。
- `scripts/`：构建与入口脚本（APT 切源、启动脚本、清理 tag 脚本）。
- `dev/replace.sh`：批量替换仓库中的硬编码第三方下载地址和 Makefile 默认镜像源。
- `docs/link.md`：统一收录第三方链接。
- `.github/workflows/docker-build-push.yml`：按镜像依赖拆分的并行构建与推送流程。

## 使用方式

```bash
make validate
make show-tags
make build-all
make push-all
```

可选：发布前清理旧 tag（支持指定版本）。

```bash
export DOCKERHUB_USERNAME=<user>
export DOCKERHUB_TOKEN=<token>
make cleanup-tags VERSION=v1.2.3
```

## 开发辅助

批量替换第三方下载地址或 apt 源：

```bash
bash dev/replace.sh
```


指定版本构建/推送：

```bash
make build-all VERSION=v1.2.3
make push-all VERSION=v1.2.3
```

可通过环境变量覆盖目标值，例如：

```bash
APT_MIRROR_NEW=http://<your-mirror>/system/kali \
DEBIAN_MIRROR_NEW=http://<your-mirror>/system/debian \
bash dev/replace.sh
```

## 说明

- 所有第三方链接统一整理在 `docs/link.md`，README 不再散落维护。
- 扩展新镜像分支请参考 `docs/EXTENDING.md`。
