#!/bin/bash

SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
FILE="$SCREENSHOT_DIR/screenshot_$TIMESTAMP.png"

mkdir -p "$SCREENSHOT_DIR"

if [ "$1" = "area" ]; then
    grim -g "$(slurp)" "$FILE"
else
    grim "$FILE"
fi

wl-copy < "$FILE"

notify-send "Screenshot saved" "$FILE"
