default: build
all: build
.PHONY: default all build install

build:
	ninja
	xcodebuild -scheme monitor

install: build
	rm -r /tmp/monitor.dst/ || true
	xcodebuild -scheme monitor install
	rsync -vr --exclude ".*" /tmp/monitor.dst/ /
	install com.sgrankin.monitor.plist ~/Library/LaunchAgents/
	launchctl unload ~/Library/LaunchAgents/com.sgrankin.monitor.plist || true
	launchctl load ~/Library/LaunchAgents/com.sgrankin.monitor.plist
