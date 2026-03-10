#!/bin/bash

# Aktive Hyprland-Session via Socket finden
export HYPRLAND_INSTANCE_SIGNATURE=$(
    for dir in "$XDG_RUNTIME_DIR/hypr/"/*/; do
        if [ -S "${dir}.socket.sock" ]; then
            basename "$dir"
            break
        fi
    done
)

if [ -z "$HYPRLAND_INSTANCE_SIGNATURE" ]; then
    notify-send "Fehler" "Hyprland-Session nicht gefunden"
    exit 1
fi

case "$1" in
    logout)
        hyprctl dispatch exec "hyprshutdown -t 'Logging out...' --post-cmd 'uwsm stop'"
        ;;
    reboot)
        hyprctl dispatch exec "hyprshutdown -t 'Rebooting...' --post-cmd 'systemctl reboot'"
        ;;
    poweroff)
        hyprctl dispatch exec "hyprshutdown -t 'Shutting down...' --post-cmd 'systemctl poweroff'"
        ;;
    *)
        echo "Usage: $0 [logout|reboot|poweroff]"
        exit 1
        ;;
esac