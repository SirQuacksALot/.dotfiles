#!/usr/bin/env bash

theme="$HOME/.config/rofi/powermenu.rasi"

lock="󰌾"
logout="󰍃"
suspend="󰒲"
reboot="󰜉"
shutdown="󰐥"
yes="󰄬"
no="󰅖"

rofi_cmd() {
    rofi -dmenu -theme "$theme"
}

confirm_cmd() {
    rofi \
        -theme-str 'window {location: center; anchor: center; width: 200px; x-offset: 0; y-offset: 0;}' \
        -theme-str 'mainbox {children: ["message","listview"]; spacing: 8px; padding: 10px;}' \
        -theme-str 'listview {columns: 2; lines: 1; spacing: 8px; fixed-columns: true;}' \
        -theme-str 'element-text {horizontal-align: 0.5; font: "JetBrainsMono Nerd Font 18";}' \
        -theme-str 'message {padding: 8px; border-radius: 5px;}' \
        -theme-str 'textbox {horizontal-align: 0.5;}' \
        -dmenu \
        -mesg "Are you sure?" \
        -theme "$theme"
}

confirm_run() {
    [[ "$(echo -e "$yes\n$no" | confirm_cmd)" == "$yes" ]] && $@
}

selected=$(echo -e "$lock\n$logout\n$suspend\n$reboot\n$shutdown" | rofi_cmd)

export HYPRLAND_INSTANCE_SIGNATURE=$(
    for dir in "$XDG_RUNTIME_DIR/hypr/"/*/; do
        if [ -S "${dir}.socket.sock" ]; then
            basename "$dir"
            break
        fi
    done
)

case "$selected" in
    "$lock")      hyprlock ;;
    "$logout")    hyprctl dispatch "hl.dsp.exec_cmd(\"hyprshutdown -t 'Logging out...' --post-cmd 'uwsm stop'\")" ;;
    "$suspend")   systemctl suspend ;;
    "$reboot")    hyprctl dispatch "hl.dsp.exec_cmd(\"hyprshutdown -t 'Rebooting...' --post-cmd 'systemctl reboot'\")" ;;
    "$shutdown")  hyprctl dispatch "hl.dsp.exec_cmd(\"hyprshutdown -t 'Shutting down...' --post-cmd 'systemctl poweroff'\")" ;;
esac
