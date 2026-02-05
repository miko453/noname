# miko453/headless 镜像矩阵

镜像仓库：`docker.io/miko453/headless`

## 分支关系

```text
base (SSH only)
├─ lite (XFCE4 + VNC + Chrome + RealVNC Viewer + xfce4-screenshooter)
│  ├─ lite-novnc (复用 lite)
│  ├─ lite-rdp
│  └─ lite-novnc-rdp
├─ xfull (复用 lite，把 xfce4 升级为 kali-desktop-xfce)
│  └─ xfull-remote (合并 noVNC + RDP)
├─ full (复用 xfull：noVNC + NoMachine + PulseAudio + AnyDesk + RDP 全量)
└─ icewm-thin (极简 IceWM + RealVNC Viewer，无 Chrome)
   └─ icewm-thin-rdp
```

## 关键点

- `base` 是 SSH only。
- `lite` 增加 `xfce4-screenshooter`。
- `xfull` 的 noVNC 和 RDP 已合并为一个镜像：`xfull-remote`。
- `full` 不再拆子分支，直接全功能。
- OpenBox 改为 IceWM。
- APT 保持原有 `/system/kali` 镜像并带失败回滚。
- deepnote 特殊版使用 `/system/debian`，见 `Dockerfile.deepnote-xfull`。

## Deepnote 专用镜像

- 基础：`deepnote/python:3.13`
- 目标：达到 xfull 体验（XFCE4 + noVNC）
- 关键要求已实现：
  - `xfce4 xfce4-goodies` 安装时 **不加** `--no-install-recommends`
  - 镜像源切到 `/system/debian`（bullseye）

## 构建/推送

```bash
make show-tags
make build-all
make push-all
```

## Docker Hub 删除旧 tag（可选）

你给的 token 有删除权限时，可在 push 前执行：

```bash
export DOCKERHUB_USERNAME=miko453
export DOCKERHUB_TOKEN=<token>
make cleanup-tags VERSION=<version>
```

## Actions 需要的密钥

仓库 `Settings -> Secrets and variables -> Actions`：

- `DOCKERHUB_USERNAME`
- `DOCKERHUB_TOKEN`

## 扩展文档

新增分支开发流程见：`docs/EXTENDING.md`

## NoMachine 固定地址

- `https://web9001.nomachine.com/download/9.3/Linux/nomachine_9.3.7_1_amd64.deb`
