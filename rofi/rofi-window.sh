#!/bin/bash
# Window-Switcher mit Thumbnails
# Speichern unter: ~/.config/rofi/rofi-window.sh

windows=$(hyprctl clients -j)

# Wenn kein Argument – Liste ausgeben
if [ -z "$*" ]; then
    echo "$windows" | jq -r '.[] | select(.mapped == true) | .title + "\t" + .address' | \
    while IFS=$'\t' read -r title address; do
        short_title="${title:0:30}"
        [ ${#title} -gt 30 ] && short_title="${short_title}…"
        printf "%s\0icon\x1fthumbnail://%s\n" "$short_title" "$address"
    done
    exit 0
fi

# Wenn Fenster ausgewählt – zu dem Fenster wechseln
SELECTED="$*"
ADDRESS=$(hyprctl clients -j | jq -r --arg title "${SELECTED:0:30}" \
    '.[] | select(.title | startswith($title)) | .address' | head -1)

if [ -n "$ADDRESS" ]; then
    hyprctl dispatch focuswindow "address:$ADDRESS"
fi