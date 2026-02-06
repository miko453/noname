SHELL := /bin/bash

REGISTRY ?= docker.io
IMAGE ?= miko453/headless
VERSION ?= latest
APT_MIRROR ?= http://mirrors.7.b.0.5.0.7.4.0.1.0.0.2.ip6.arpa/system/kali
DEBIAN_MIRROR ?= http://mirrors.7.b.0.5.0.7.4.0.1.0.0.2.ip6.arpa/system/debian

IMAGE_base := $(REGISTRY)/$(IMAGE):base-$(VERSION)
IMAGE_lite := $(REGISTRY)/$(IMAGE):lite-$(VERSION)
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

ALL_TARGETS := base lite lite-novnc lite-rdp lite-novnc-rdp xfull xfull-remote full icewm-thin icewm-thin-novnc icewm-thin-rdp deepnote-xfull
TAGS := $(foreach t,$(ALL_TARGETS),$(t)-$(VERSION))

.PHONY: $(addprefix build-,$(ALL_TARGETS)) $(addprefix push-,$(ALL_TARGETS)) build-all push-all cleanup-tags show-tags optimize

# ---------- Build ----------
build-base:
	docker build -f images/Dockerfile.base --build-arg APT_MIRROR=$(APT_MIRROR) -t $(IMAGE_base) .

build-deepnote-xfull:
	docker build -f images/Dockerfile.deepnote-xfull --build-arg APT_MIRROR=$(DEBIAN_MIRROR) -t $(IMAGE_deepnote-xfull) .

build-lite:
	docker build -f images/Dockerfile.lite --build-arg BASE_IMAGE=$(IMAGE_base) -t $(IMAGE_lite) .

build-lite-novnc:
	docker build -f images/Dockerfile.lite-novnc --build-arg BASE_IMAGE=$(IMAGE_lite) -t $(IMAGE_lite-novnc) .

build-lite-rdp:
	docker build -f images/Dockerfile.lite-rdp --build-arg BASE_IMAGE=$(IMAGE_lite) -t $(IMAGE_lite-rdp) .

build-lite-novnc-rdp:
	docker build -f images/Dockerfile.lite-novnc-rdp --build-arg BASE_IMAGE=$(IMAGE_lite-novnc) -t $(IMAGE_lite-novnc-rdp) .

build-xfull:
	docker build -f images/Dockerfile.xfull --build-arg BASE_IMAGE=$(IMAGE_lite) -t $(IMAGE_xfull) .

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
push-%:
	@echo "[INFO] Cleanup old tags for $*"
	@./scripts/delete-dockerhub-tags.sh $(IMAGE) $*-${VERSION} || true
	docker push $(IMAGE_$*)

# ---------- Utilities ----------
build-all: $(addprefix build-,$(ALL_TARGETS))
push-all: $(addprefix push-,$(ALL_TARGETS))

cleanup-tags:
	@./scripts/delete-dockerhub-tags.sh $(IMAGE) $(TAGS) || true

show-tags:
	@$(foreach t,$(ALL_TARGETS),echo "$(t)=$(IMAGE_$(t))";)

optimize:
	bash -n apt.sh scripts/apt-debian.sh scripts/chrome-wrapper.sh scripts/delete-dockerhub-tags.sh scripts/entrypoints/*.sh dev/replace.sh
	@find . -type l -print | sed 's#^#symlink: #' || true
	@echo "[optimize] shell syntax check passed"
