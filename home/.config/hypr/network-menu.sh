#!/bin/bash

# Wi-Fi status
wifi_state=$(nmcli radio wifi)

# Bluetooth status

if systemctl is-active --quiet bluetooth; then
    bt_available=true
    bt_state=$(timeout 2 bluetoothctl show 2>/dev/null | awk '/Powered:/ {print $2}')
else
    bt_available=false
    bt_state="unavailable"
fi

menu="Wi-Fi [$wifi_state]"

if [ "$bt_available" = true ]; then
    menu="$menu
Bluetooth [$bt_state]"
fi

menu="$menu
────────────"

# Wi-Fi networks
while IFS= read -r ssid; do
    [ -z "$ssid" ] && continue
    menu="$menu
Wi-Fi: $ssid"
done < <(
    nmcli -t -f SSID device wifi list 2>/dev/null |
    sed '/^$/d' |
    sort -u
)

# Bluetooth devices
if [ "$bt_available" = true ]; then
    while IFS= read -r device; do
        [ -z "$device" ] && continue
        menu="$menu
BT: $device"
    done < <(
        bluetoothctl devices 2>/dev/null |
        cut -d' ' -f3-
    )
fi

choice=$(printf '%b\n' "$menu" | wofi --dmenu --prompt "Network")

[ -z "$choice" ] && exit 0

case "$choice" in

    "Wi-Fi [enabled]")
        nmcli radio wifi off
        ;;

    "Wi-Fi [disabled]")
        nmcli radio wifi on
        ;;

    "Bluetooth [yes]")
        bluetoothctl power off
        ;;

    "Bluetooth [no]")
        bluetoothctl power on
        ;;

    Wi-Fi:*)
        ssid="${choice#Wi-Fi: }"
        nmcli device wifi connect "$ssid"
        ;;

    BT:*)
        device="${choice#BT: }"
        mac=$(bluetoothctl devices |
              grep -F "$device" |
              awk '{print $2}')

        [ -n "$mac" ] && bluetoothctl connect "$mac"
        ;;

esac
