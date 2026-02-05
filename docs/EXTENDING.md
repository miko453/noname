# 扩展分支指南

## 1) 选择父镜像

推荐链路：

- 仅 SSH：`base`
- 轻桌面：`lite`
- 完整 Kali 桌面：`xfull`
- 全功能远控：`full`

## 2) 新增 Dockerfile

示例：新增 `Dockerfile.myprofile`

```dockerfile
ARG BASE_IMAGE=miko453/headless:xfull
FROM ${BASE_IMAGE}

RUN /usr/local/bin/apt.sh switch && \
    apt-get install -y --no-install-recommends <your-packages> && \
    /usr/local/bin/apt.sh restore && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
```

## 3) 接入 Makefile

- 新增 `<PROFILE>_IMAGE` 变量
- 新增 `build-<profile>` 与 `push-<profile>` target
- 挂到 `build-all` / `push-all`

## 4) 接入 CI

GitHub Actions 默认读取 `make build-all` 与 `make push-all`，只需确保 Makefile 里已包含新 profile。

## 5) 发布前清理旧 tag（可选）

```bash
export DOCKERHUB_USERNAME=<user>
export DOCKERHUB_TOKEN=<token>
make cleanup-tags VERSION=<ver>
```

> `cleanup-tags` 依赖 Docker Hub API 删除 tag，请确认 token 具备删除权限。
