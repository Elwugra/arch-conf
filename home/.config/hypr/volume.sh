#!/bin/bash

wpctl set-volume @DEFAULT_AUDIO_SINK@ "$1"

VOL=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2*100)}')

notify-send -h string:x-canonical-private-synchronous:volume \
            -h int:value:$VOL\
            "Volume" "${VOL}%"
