#!/bin/bash

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

# Запустить демон, если он ещё не работает
pgrep -x awww-daemon >/dev/null || awww-daemon &

sleep 1

# Взять первую найденную картинку
WALLPAPER=$(find "$WALLPAPER_DIR" -maxdepth 1 -type f \
    \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | sort | head -n 1)

[ -n "$WALLPAPER" ] && awww img "$WALLPAPER"
