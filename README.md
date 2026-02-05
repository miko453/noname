# miko453/headless 镜像矩阵

镜像仓库：`docker.io/miko453/headless`

## 分支关系（当前规范）

```text
第一层：base、deepnote
├─ 第二层（基于 base 派生）：lite、icewm-thin、xfull
│  ├─ 第三层（lite 分支）：lite-novnc、lite-rdp、lite-novnc-rdp
│  ├─ 第三层（icewm-thin 分支）：icewm-thin-rdp
│  └─ 第三层（xfull 分支）：xfull-remote
│     └─ 第四层：full（基于 xfull-remote）
```

## 关键点

- `base` 是 SSH only。
- `lite` 增加 `xfce4-screenshooter`。
- `xfull` 的 noVNC 和 RDP 在 `xfull-remote`。
- `full` 基于 `xfull-remote` 继续叠加 NoMachine / 音频 / 远控组件。
- OpenBox 改为 IceWM。
- APT 保持原有 `/system/kali` 镜像并带失败回滚。
- deepnote 特殊版使用 `/system/debian`，见 `Dockerfile.deepnote-xfull`。
- 所有主要运行态镜像默认保留端口：SSH `22`、VNC `5901`，带 RDP 的镜像额外提供 `3389`。
- `start-sshd.sh` 默认账号口令：`root/toor`、`qwe/toor`（可通过环境变量覆盖）。

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
