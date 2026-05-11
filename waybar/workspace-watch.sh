#!/bin/bash

WAYBAR_DIR="$HOME/.config/waybar"
CURRENT_MODE="expanded"

log() {
    echo "[waybar-watcher] $1" >&2
}

generate_style() {
    log "Generating style: $CURRENT_MODE"
    "$WAYBAR_DIR/generate-style.sh" "$CURRENT_MODE"
}

get_window_count() {
    local ws_id
    ws_id=$(hyprctl monitors -j | jq ".[] | select(.name == \"$WAYBAR_MONITOR\") | .activeWorkspace.id")
    if [[ -z "$ws_id" ]]; then
        log "WARN: Monitor '$WAYBAR_MONITOR' nicht gefunden, fallback auf activeworkspace"
        ws_id=$(hyprctl activeworkspace -j | jq '.id')
    fi
    hyprctl clients -j | jq "[.[] | select(.workspace.id == $ws_id)] | length"
}

if [[ -z "$HYPRLAND_INSTANCE_SIGNATURE" ]]; then
    log "ERROR: HYPRLAND_INSTANCE_SIGNATURE nicht gesetzt!"
    exit 1
fi

SOCKET_PATH="${XDG_RUNTIME_DIR}/hypr/${HYPRLAND_INSTANCE_SIGNATURE}/.socket2.sock"

if [[ ! -S "$SOCKET_PATH" ]]; then
    log "ERROR: Socket nicht gefunden: $SOCKET_PATH"
    exit 1
fi

log "Verbinde mit Socket: $SOCKET_PATH"

# Warte bis Waybar in den Layers erscheint (Race condition nach Start)
WAYBAR_MONITOR=""
for i in $(seq 1 15); do
    WAYBAR_MONITOR=$(hyprctl layers -j | jq -r 'to_entries[] | select(.value.levels? | .. | objects | .namespace? == "waybar") | .key' 2>/dev/null | head -1)
    [[ -n "$WAYBAR_MONITOR" ]] && break
    log "Warte auf Waybar-Layer... ($i/15)"
    sleep 1
done

if [[ -z "$WAYBAR_MONITOR" ]]; then
    log "ERROR: Waybar läuft nicht oder nicht als Client erkennbar!"
    exit 1
fi
log "Waybar-Monitor: $WAYBAR_MONITOR"

# Initialen Zustand prüfen
count=$(get_window_count)
if [[ "$count" -gt 0 ]]; then
    CURRENT_MODE="expanded"
else
    CURRENT_MODE="collapsed"
fi
generate_style

socat -U - UNIX-CONNECT:"$SOCKET_PATH" | \
while read -r line; do

    if [[ "$line" =~ ^monitoradded ]]; then
        log "Monitor added: $line"
        sleep 0.5
        generate_style
    fi

    if [[ "$line" =~ ^monitorremoved ]]; then
        log "Monitor removed: $line"
        sleep 0.5
        generate_style
    fi

    if [[ "$line" =~ ^(workspace|openwindow|closewindow|movewindow) ]]; then
        count=$(get_window_count)

        if [[ "$count" -gt 0 ]]; then
            mode="expanded"
        else
            mode="collapsed"
        fi

        if [[ "$mode" != "$CURRENT_MODE" ]]; then
            log "Mode switch: $CURRENT_MODE -> $mode (windows: $count)"
            CURRENT_MODE="$mode"
            generate_style
        fi
    fi

done