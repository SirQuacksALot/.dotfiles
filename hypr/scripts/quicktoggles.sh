#!/usr/bin/env bash

theme="$HOME/.config/rofi/quicktoggles.rasi"

# WiFi
wifi_on=$(nmcli radio wifi)
[[ "$wifi_on" == "enabled" ]] && wifi="󰤨 " || wifi="󰤮 "

# Bluetooth
bt_on=$(bluetoothctl show | grep -c "Powered: yes")
[[ "$bt_on" -gt 0 ]] && bt="󰂰" || bt="󰂲"

# Idle inhibitor
inh_pid=/tmp/idle-inhibitor.pid
if [[ -f "$inh_pid" ]] && kill -0 "$(cat "$inh_pid")" 2>/dev/null; then
    inhibit="󰅶"
else
    inhibit="󰛊"
fi

# PPD
case "$(powerprofilesctl get)" in
    performance) ppd="" ;;
    balanced)    ppd="" ;;
    power-saver) ppd="󰌪" ;;
esac

# Show menu — use index for reliable matching
selected=$(echo -e "$wifi\n$bt\n$inhibit\n$ppd" | rofi -dmenu -theme "$theme" -format i)

case "$selected" in
    0)  # WiFi
        [[ "$wifi_on" == "enabled" ]] && nmcli radio wifi off || nmcli radio wifi on
        ;;
    1)  # Bluetooth
        if [[ "$bt_on" -gt 0 ]]; then
            bluetoothctl power off
        else
            rfkill unblock bluetooth
            sleep 0.3
            bluetoothctl power on
        fi
        ;;
    2)  # Idle inhibitor (Wayland zwp_idle_inhibitor_v1 via GTK)
        if [[ -f "$inh_pid" ]] && kill -0 "$(cat "$inh_pid")" 2>/dev/null; then
            kill "$(cat "$inh_pid")"
            rm -f "$inh_pid"
        else
            nohup python3 "$HOME/.config/hypr/scripts/idle-inhibit.py" >/dev/null 2>&1 &
            echo $! > "$inh_pid"
            disown
        fi
        ;;
    3)  # PPD cycle
        p=$(powerprofilesctl get)
        if [[ "$p" == "power-saver" ]]; then
            powerprofilesctl set balanced
        elif [[ "$p" == "balanced" ]]; then
            powerprofilesctl set performance
        else
            powerprofilesctl set power-saver
        fi
        ;;
esac
