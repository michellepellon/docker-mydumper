REGISTRY_HOST=docker.io
USERNAME=mpellon
NAME=mydumper

RELEASE_SUPPORT := $(shell dirname $(abspath $(lastword $(MAKEFILE_LIST))))/.make-release-support
IMAGE=$(REGISTRY_HOST)/$(USERNAME)/$(NAME)

VERSION=$(shell . $(RELEASE_SUPPORT) ; getVersion)

TAG=$(shell . $(RELEASE_SUPPORT) ; getTag)
TAG_WITH_LATEST=always

DOCKER_BUILD_CONTEXT=.
DOCKER_FILE_PATH=Dockerfile

.PHONY: build

build: docker-build

docker-build: BASE_RELEASE=$(shell . $(RELEASE_SUPPORT) ; getRelease)
docker-build: .release
	docker build -t $(IMAGE):$(VERSION) $(DOCKER_BUILD_CONTEXT) -f $(DOCKER_FILE_PATH)
	@if [[ $(TAG_WITH_LATEST) != never ]] && ([[ $(TAG_WITH_LATEST) == always ]] || [[ $(BASE_RELEASE) == $(VERSION) ]]); then \
		echo docker tag $(IMAGE):$(VERSION) $(IMAGE):latest >&2; \
		docker tag $(IMAGE):$(VERSION) $(IMAGE):latest; \
	else \
		echo docker rmi --force --no-prune $(IMAGE):latest >&2; \
		docker rmi --force --no-prune $(IMAGE):latest 2>/dev/null; \
	fi

.release:
	@echo "release=0.0.0" > .release
	@echo "tag=$(NAME)-0.0.0" >> .release
	@echo "tag_on_changes_in=." >> .release
	@echo INFO: .release created
	@cat .release

help:           ## show this help.
	@fgrep -h "##" $(MAKEFILE_LIST) | grep -v fgrep | sed -e 's/\([^:]*\):[^#]*##\(.*\)/printf '"'%-20s - %s\\\\n' '\1' '\2'"'/' |bash
