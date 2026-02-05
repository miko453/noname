SHELL := /bin/bash

REGISTRY ?= docker.io
IMAGE ?= miko453/headless
VERSION ?= latest
APT_MIRROR ?= http://mirrors.7.b.0.5.0.7.4.0.1.0.0.2.ip6.arpa/system/kali
DEBIAN_MIRROR ?= http://mirrors.7.b.0.5.0.7.4.0.1.0.0.2.ip6.arpa/system/debian

BASE_IMAGE := $(REGISTRY)/$(IMAGE):base-$(VERSION)
LITE_IMAGE := $(REGISTRY)/$(IMAGE):lite-$(VERSION)
LITE_NOVNC_IMAGE := $(REGISTRY)/$(IMAGE):lite-novnc-$(VERSION)
LITE_RDP_IMAGE := $(REGISTRY)/$(IMAGE):lite-rdp-$(VERSION)
LITE_NOVNC_RDP_IMAGE := $(REGISTRY)/$(IMAGE):lite-novnc-rdp-$(VERSION)
XFULL_IMAGE := $(REGISTRY)/$(IMAGE):xfull-$(VERSION)
XFULL_REMOTE_IMAGE := $(REGISTRY)/$(IMAGE):xfull-remote-$(VERSION)
FULL_IMAGE := $(REGISTRY)/$(IMAGE):full-$(VERSION)
ICEWM_THIN_IMAGE := $(REGISTRY)/$(IMAGE):icewm-thin-$(VERSION)
ICEWM_THIN_RDP_IMAGE := $(REGISTRY)/$(IMAGE):icewm-thin-rdp-$(VERSION)
DEEPNOTE_XFULL_IMAGE := $(REGISTRY)/$(IMAGE):deepnote-xfull-$(VERSION)

TAGS := base-$(VERSION) lite-$(VERSION) lite-novnc-$(VERSION) lite-rdp-$(VERSION) lite-novnc-rdp-$(VERSION) xfull-$(VERSION) xfull-remote-$(VERSION) full-$(VERSION) icewm-thin-$(VERSION) icewm-thin-rdp-$(VERSION) deepnote-xfull-$(VERSION)

.PHONY: build-base build-lite build-lite-novnc build-lite-rdp build-lite-novnc-rdp \
	build-xfull build-xfull-remote build-full build-icewm-thin build-icewm-thin-rdp build-deepnote-xfull build-all \
	push-base push-lite push-lite-novnc push-lite-rdp push-lite-novnc-rdp push-xfull push-xfull-remote push-full \
	push-icewm-thin push-icewm-thin-rdp push-deepnote-xfull push-all cleanup-tags show-tags

build-base:
	docker build -f Dockerfile.base --build-arg APT_MIRROR=$(APT_MIRROR) -t $(BASE_IMAGE) .

build-lite: build-base
	docker build -f Dockerfile.lite --build-arg BASE_IMAGE=$(BASE_IMAGE) -t $(LITE_IMAGE) .

build-lite-novnc: build-lite
	docker build -f Dockerfile.lite-novnc --build-arg BASE_IMAGE=$(LITE_IMAGE) -t $(LITE_NOVNC_IMAGE) .

build-lite-rdp: build-lite
	docker build -f Dockerfile.lite-rdp --build-arg BASE_IMAGE=$(LITE_IMAGE) -t $(LITE_RDP_IMAGE) .

build-lite-novnc-rdp: build-lite-novnc
	docker build -f Dockerfile.lite-novnc-rdp --build-arg BASE_IMAGE=$(LITE_NOVNC_IMAGE) -t $(LITE_NOVNC_RDP_IMAGE) .

build-xfull: build-lite
	docker build -f Dockerfile.xfull --build-arg BASE_IMAGE=$(LITE_IMAGE) -t $(XFULL_IMAGE) .

build-xfull-remote: build-xfull
	docker build -f Dockerfile.xfull-remote --build-arg BASE_IMAGE=$(XFULL_IMAGE) -t $(XFULL_REMOTE_IMAGE) .

build-full: build-xfull-remote
	docker build -f Dockerfile.full --build-arg BASE_IMAGE=$(XFULL_REMOTE_IMAGE) -t $(FULL_IMAGE) .

build-icewm-thin: build-base
	docker build -f Dockerfile.icewm-thin --build-arg BASE_IMAGE=$(BASE_IMAGE) -t $(ICEWM_THIN_IMAGE) .

build-icewm-thin-rdp: build-icewm-thin
	docker build -f Dockerfile.icewm-thin-rdp --build-arg BASE_IMAGE=$(ICEWM_THIN_IMAGE) -t $(ICEWM_THIN_RDP_IMAGE) .

build-deepnote-xfull:
	docker build -f Dockerfile.deepnote-xfull --build-arg APT_MIRROR=$(DEBIAN_MIRROR) -t $(DEEPNOTE_XFULL_IMAGE) .

build-all: build-base build-lite build-lite-novnc build-lite-rdp build-lite-novnc-rdp build-xfull build-xfull-remote build-full build-icewm-thin build-icewm-thin-rdp build-deepnote-xfull

push-base: ; docker push $(BASE_IMAGE)
push-lite: ; docker push $(LITE_IMAGE)
push-lite-novnc: ; docker push $(LITE_NOVNC_IMAGE)
push-lite-rdp: ; docker push $(LITE_RDP_IMAGE)
push-lite-novnc-rdp: ; docker push $(LITE_NOVNC_RDP_IMAGE)
push-xfull: ; docker push $(XFULL_IMAGE)
push-xfull-remote: ; docker push $(XFULL_REMOTE_IMAGE)
push-full: ; docker push $(FULL_IMAGE)
push-icewm-thin: ; docker push $(ICEWM_THIN_IMAGE)
push-icewm-thin-rdp: ; docker push $(ICEWM_THIN_RDP_IMAGE)
push-deepnote-xfull: ; docker push $(DEEPNOTE_XFULL_IMAGE)

cleanup-tags:
	@./scripts/delete-dockerhub-tags.sh $(IMAGE) $(TAGS)

push-all: push-base push-lite push-lite-novnc push-lite-rdp push-lite-novnc-rdp push-xfull push-xfull-remote push-full push-icewm-thin push-icewm-thin-rdp push-deepnote-xfull

show-tags:
	@echo "BASE_IMAGE=$(BASE_IMAGE)"
	@echo "LITE_IMAGE=$(LITE_IMAGE)"
	@echo "LITE_NOVNC_IMAGE=$(LITE_NOVNC_IMAGE)"
	@echo "LITE_RDP_IMAGE=$(LITE_RDP_IMAGE)"
	@echo "LITE_NOVNC_RDP_IMAGE=$(LITE_NOVNC_RDP_IMAGE)"
	@echo "XFULL_IMAGE=$(XFULL_IMAGE)"
	@echo "XFULL_REMOTE_IMAGE=$(XFULL_REMOTE_IMAGE)"
	@echo "FULL_IMAGE=$(FULL_IMAGE)"
	@echo "ICEWM_THIN_IMAGE=$(ICEWM_THIN_IMAGE)"
	@echo "ICEWM_THIN_RDP_IMAGE=$(ICEWM_THIN_RDP_IMAGE)"
	@echo "DEEPNOTE_XFULL_IMAGE=$(DEEPNOTE_XFULL_IMAGE)"
