#!/bin/bash

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
CURRENT="$WALLPAPER_DIR/current"

pgrep -x awww-daemon >/dev/null || awww-daemon &

sleep 1

WALLPAPER=$(find "$WALLPAPER_DIR" -maxdepth 1 -type f \
    \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) \
    | sort | head -n 1)

if [ -n "$WALLPAPER" ]; then
    ln -sf "$WALLPAPER" "$CURRENT"   
    awww img "$CURRENT"              
fi
