#!/bin/sh
CACHE="$HOME/.cache/waybar-pacman.json"

# Cache anzeigen falls vorhanden und nicht älter als 60 Sekunden
if [ -f "$CACHE" ] && [ $(( $(date +%s) - $(date +%s -r "$CACHE") )) -lt 60 ]; then
  cat "$CACHE"
else
  echo '{"text":"","alt":"default","tooltip":"Checking...","class":"default"}'
fi

waybar-updates | tee >(while IFS= read -r line; do echo "$line" > "$CACHE"; done)