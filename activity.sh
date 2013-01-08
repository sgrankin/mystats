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
}

log_activity
sleep 30
log_activity

# vim:noet:
