SHELL := /bin/bash

REGISTRY ?= docker.io
IMAGE ?= miko453/headless
VERSION ?= latest
APT_MIRROR ?= http://mirrors.7.b.0.5.0.7.4.0.1.0.0.2.ip6.arpa/system/kali
DEBIAN_MIRROR ?= http://mirrors.7.b.0.5.0.7.4.0.1.0.0.2.ip6.arpa/system/debian

# ---------- 镜像定义 ----------
IMAGE_base := $(REGISTRY)/$(IMAGE):base-$(VERSION)
IMAGE_lite := $(REGISTRY)/$(IMAGE):lite-$(VERSION)
IMAGE_lite_latest := $(REGISTRY)/$(IMAGE):latest
IMAGE_lite-novnc := $(REGISTRY)/$(IMAGE):lite-novnc-$(VERSION)
IMAGE_lite-rdp := $(REGISTRY)/$(IMAGE):lite-rdp-$(VERSION)
IMAGE_lite-novnc-rdp := $(REGISTRY)/$(IMAGE):lite-novnc-rdp-$(VERSION)
IMAGE_xfull := $(REGISTRY)/$(IMAGE):xfull-$(VERSION)
IMAGE_xfull-remote := $(REGISTRY)/$(IMAGE):xfull-remote-$(VERSION)
IMAGE_full := $(REGISTRY)/$(IMAGE):full-$(VERSION)
IMAGE_icewm-thin := $(REGISTRY)/$(IMAGE):icewm-thin-$(VERSION)
IMAGE_icewm-thin-novnc := $(REGISTRY)/$(IMAGE):icewm-thin-novnc-$(VERSION)
IMAGE_icewm-thin-rdp := $(REGISTRY)/$(IMAGE):icewm-thin-rdp-$(VERSION)
IMAGE_deepnote-xfull := $(REGISTRY)/$(IMAGE):deepnote-xfull-$(VERSION)

ALL_TARGETS := \
	base \
	lite \
	lite-novnc \
	lite-rdp \
	lite-novnc-rdp \
	xfull \
	xfull-remote \
	full \
	icewm-thin \
	icewm-thin-novnc \
	icewm-thin-rdp \
	deepnote-xfull

.PHONY: $(addprefix build-,$(ALL_TARGETS)) $(addprefix push-,$(ALL_TARGETS)) \
	build-all push-all cleanup-tags show-tags optimize validate help

help:
	@echo "常用目标:"
	@echo "  make validate                # 检查本地依赖工具"
	@echo "  make show-tags VERSION=v1    # 查看将要使用的镜像 tag"
	@echo "  make build-all VERSION=v1    # 构建全部镜像"
	@echo "  make push-all VERSION=v1     # 推送全部镜像"
	@echo "  make cleanup-tags VERSION=v1 # 清理同版本 tag"

validate:
	@command -v docker >/dev/null || (echo "[validate] docker 未安装" && exit 1)
	@command -v bash >/dev/null || (echo "[validate] bash 未安装" && exit 1)
	@echo "[validate] 环境检查通过"

# ---------- Build ----------
build-base:
	docker build -f images/Dockerfile.base --build-arg APT_MIRROR=$(APT_MIRROR) -t $(IMAGE_base) .

build-deepnote-xfull:
	docker build -f images/Dockerfile.deepnote-xfull --build-arg APT_MIRROR=$(DEBIAN_MIRROR) -t $(IMAGE_deepnote-xfull) .

build-lite:
	docker build -f images/Dockerfile.lite --build-arg BASE_IMAGE=$(IMAGE_base) \
	-t $(IMAGE_lite) -t $(IMAGE_lite_latest) .

build-lite-novnc:
	docker build -f images/Dockerfile.lite-novnc --build-arg BASE_IMAGE=$(IMAGE_lite) -t $(IMAGE_lite-novnc) .

build-lite-rdp:
	docker build -f images/Dockerfile.lite-rdp --build-arg BASE_IMAGE=$(IMAGE_lite) -t $(IMAGE_lite-rdp) .

build-lite-novnc-rdp:
	docker build -f images/Dockerfile.lite-novnc-rdp --build-arg BASE_IMAGE=$(IMAGE_lite-novnc) -t $(IMAGE_lite-novnc-rdp) .

build-xfull:
	docker build -f images/Dockerfile.xfull --build-arg BASE_IMAGE=$(IMAGE_base) -t $(IMAGE_xfull) .

build-xfull-remote:
	docker build -f images/Dockerfile.xfull-remote --build-arg BASE_IMAGE=$(IMAGE_xfull) -t $(IMAGE_xfull-remote) .

build-full:
	docker build -f images/Dockerfile.full --build-arg BASE_IMAGE=$(IMAGE_xfull-remote) -t $(IMAGE_full) .

build-icewm-thin:
	docker build -f images/Dockerfile.icewm-thin --build-arg BASE_IMAGE=$(IMAGE_base) -t $(IMAGE_icewm-thin) .

build-icewm-thin-novnc:
	docker build -f images/Dockerfile.icewm-thin-novnc --build-arg BASE_IMAGE=$(IMAGE_icewm-thin) -t $(IMAGE_icewm-thin-novnc) .

build-icewm-thin-rdp:
	docker build -f images/Dockerfile.icewm-thin-rdp --build-arg BASE_IMAGE=$(IMAGE_icewm-thin) -t $(IMAGE_icewm-thin-rdp) .

# ---------- Push ----------
push-base:
	@./scripts/delete-dockerhub-tags.sh $(IMAGE) base-$(VERSION) || true
	docker push $(IMAGE_base)

push-lite:
	@./scripts/delete-dockerhub-tags.sh $(IMAGE) lite-$(VERSION) || true
	@./scripts/delete-dockerhub-tags.sh $(IMAGE) latest || true
	docker push $(IMAGE_lite)
	docker push $(IMAGE_lite_latest)

push-lite-novnc:
	docker push $(IMAGE_lite-novnc)

push-lite-rdp:
	docker push $(IMAGE_lite-rdp)

push-lite-novnc-rdp:
	docker push $(IMAGE_lite-novnc-rdp)

push-xfull:
	docker push $(IMAGE_xfull)

push-xfull-remote:
	docker push $(IMAGE_xfull-remote)

push-full:
	docker push $(IMAGE_full)

push-icewm-thin:
	docker push $(IMAGE_icewm-thin)

push-icewm-thin-novnc:
	docker push $(IMAGE_icewm-thin-novnc)

push-icewm-thin-rdp:
	docker push $(IMAGE_icewm-thin-rdp)

push-deepnote-xfull:
	docker push $(IMAGE_deepnote-xfull)

# ---------- Utilities ----------
build-all: $(addprefix build-,$(ALL_TARGETS))
push-all: $(addprefix push-,$(ALL_TARGETS))

cleanup-tags:
	@./scripts/delete-dockerhub-tags.sh $(IMAGE) $(ALL_TARGETS:%=%-$(VERSION)) || true

show-tags:
	@$(foreach t,$(ALL_TARGETS),echo "$(t)=$(IMAGE_$(t))";)

optimize:
	bash -n scripts/apt.sh scripts/apt-debian.sh scripts/chrome-wrapper.sh scripts/delete-dockerhub-tags.sh scripts/entrypoints/*.sh dev/replace.sh
	@find . -type l -print | sed 's#^#symlink: #' || true
	@echo "[optimize] shell syntax check passed"
