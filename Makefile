default: build
all: build
.PHONY: default all build install

build:
	ninja
	xcodebuild -scheme monitor

install: build
	xcodebuild -scheme monitor install
	rsync -av --exclude ".*" /tmp/monitor.dst/ /
