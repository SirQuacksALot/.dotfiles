#!/bin/bash

WAYBAR_DIR="$HOME/.config/waybar"

# Alte Instanzen beenden
pkill -x waybar
# pkill -f workspace-watch.sh
sleep 0.1


# Generate intial style
"$WAYBAR_DIR/generate-style.sh" collapsed
sleep 0.5

# Waybar zuerst starten
waybar &
sleep 0.5  # warten bis waybar oben ist

# Dann erst Watcher starten
# "$WAYBAR_DIR/workspace-watch.sh" &

# Auf waybar warten (Logs sichtbar im Terminal)
wait