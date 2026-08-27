#!/bin/bash

BAR_LENGTH=20

while true; do
    STATUS=$(playerctl status 2>/dev/null || echo "Stopped")

    if [ "$STATUS" = "Playing" ] || [ "$STATUS" = "Paused" ]; then

        ARTIST=$(playerctl metadata artist 2>/dev/null)
        TITLE=$(playerctl metadata title 2>/dev/null)

        POSITION=$(playerctl position 2>/dev/null)
        LENGTH=$(playerctl metadata mpris:length 2>/dev/null)

        POSITION=${POSITION%.*}
        LENGTH=$((LENGTH / 1000000))

        if [ -z "$POSITION" ] || [ -z "$LENGTH" ] || [ "$LENGTH" -le 0 ]; then
            POSITION=0
            LENGTH=1
        fi

        FILLED=$((POSITION * BAR_LENGTH / LENGTH))

        if [ "$FILLED" -gt "$BAR_LENGTH" ]; then
            FILLED=$BAR_LENGTH
        fi

        EMPTY=$((BAR_LENGTH - FILLED))

        BAR=$(printf '━%.0s' $(seq 1 "$FILLED"))
        BAR+=$(printf '─%.0s' $(seq 1 "$EMPTY"))

        POSITION_MIN=$((POSITION / 60))
        POSITION_SEC=$((POSITION % 60))

        LENGTH_MIN=$((LENGTH / 60))
        LENGTH_SEC=$((LENGTH % 60))

        TIME=$(printf "%02d:%02d / %02d:%02d" \
            "$POSITION_MIN" "$POSITION_SEC" \
            "$LENGTH_MIN" "$LENGTH_SEC")

        if [ "$STATUS" = "Playing" ]; then
            ICON="󰎆"
        else
            ICON="󰏤"
        fi

        TEXT="$ICON  $ARTIST — $TITLE"

TOOLTIP=$(printf '%s\n\n%s\n%s' \
    "$ARTIST — $TITLE" \
    "$BAR" \
    "$TIME")

        jq -cn \
            --arg text "$TEXT" \
            --arg tooltip "$TOOLTIP" \
            '{text:$text, tooltip:$tooltip}'

    else

        jq -cn \
            '{text:"󰎆  No music", tooltip:"No music playing"}'

    fi

    sleep 1
done
