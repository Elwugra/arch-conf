#!/bin/bash

RECORD_DIR="$HOME/Videos/Screenrecords"

mkdir -p "$RECORD_DIR"

if pgrep -x wf-recorder >/dev/null; then
    pkill -INT -x wf-recorder
    notify-send "Screen recording" "Recording stopped"
    exit 0
fi

FILENAME="$(date +"%Y-%m-%d_%H-%M-%S").mp4"
FILE="$RECORD_DIR/$FILENAME"

if [ "$1" = "area" ]; then
    GEOMETRY="$(slurp)"

    if [ -z "$GEOMETRY" ]; then
        exit 0
    fi

    wf-recorder -g "$GEOMETRY" -f "$FILE" &
else
    wf-recorder -f "$FILE" &
fi

notify-send "Screen recording" "Recording started"
