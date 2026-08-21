#!/bin/bash

options="Lock\nSuspend\nLogout\nReboot\nShutdown"

choice=$(printf "$options" | wofi --dmenu --prompt "Power")

case "$choice" in
    "Lock")
        hyprlock
        ;;
    "Suspend")
        systemctl suspend
        ;;
    "Logout")
        hyprctl dispatch exit
        ;;
    "Reboot")
        systemctl reboot
        ;;
    "Shutdown")
        systemctl poweroff
        ;;
esac
