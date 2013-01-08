#!/bin/bash
set -e
FILE="${BASH_SOURCE[0]%.*}/`hostname -s`-`date +%FT%T%z`.jpeg"
mkdir -p "`dirname $FILE`"
/usr/local/bin/imagesnap -d "FaceTime HD Camera (Built-in)" -q "$FILE"
