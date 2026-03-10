#!/bin/bash

MODE="${1:-expanded}"
WAYBAR_DIR="$HOME/.config/waybar"
OUT="$WAYBAR_DIR/style.css"

# Base direkt einfuegen
cat "$WAYBAR_DIR/styles/base.css" > "$OUT"

# Mode-Style direkt anhaengen
echo "" >> "$OUT"
echo "/* Mode: $MODE */" >> "$OUT"
cat "$WAYBAR_DIR/styles/style-${MODE}.css" >> "$OUT"

# Waybar reload
if pgrep -x waybar > /dev/null; then
    pkill -SIGUSR2 waybar
fi