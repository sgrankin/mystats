#!/bin/bash
set -e

FILE="${BASH_SOURCE[0]%.*}/`hostname -s`-`date -u +%F`.yml"
mkdir -p "`dirname "$FILE"`"

function log_activity()
{
  cat <<EOF >> $FILE
-
  date: `date +%FT%T%z`
  idle: $((`/usr/sbin/ioreg -c IOHIDSystem | sed -e '/HIDIdleTime/!{ d' -e 't' -e '}' -e 's/.* = //g' -e 'q'` / 1000000000 ))
  foreground_app: `/usr/bin/osascript -e 'tell application "System Events"' -e 'set frontApp to name of first application process whose frontmost is true' -e 'end tell'`
EOF
if [ 0 -lt `osascript -e 'tell application "System Events" to count (processes whose name is "itunes")'` ]; then
  cat <<EOF >> $FILE
  itunes:
    state: `osascript -e 'tell application "iTunes" to player state as string'`
    artist: `osascript -e 'tell application "iTunes" to artist of current track'`
    album: `osascript -e 'tell application "iTunes" to album of current track'`
    title: `osascript -e 'tell application "iTunes" to name of current track'`
EOF
fi
}

log_activity
sleep 30
log_activity

# vim:noet:
