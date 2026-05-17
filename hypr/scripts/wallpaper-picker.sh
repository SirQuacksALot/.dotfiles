#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/Bilder/Wallpapers"
CACHE_DIR="$HOME/.cache/rofi-wallpaper"
THUMB_SIZE="300x300"

mkdir -p "$CACHE_DIR"

# Build rofi entries with thumbnails
entries=""
while IFS= read -r -d '' file; do
    name=$(basename "$file")
    thumb="$CACHE_DIR/${name%.*}.png"

    if [[ ! -f "$thumb" ]]; then
        magick "$file" -thumbnail "${THUMB_SIZE}^" -gravity center -extent "$THUMB_SIZE" "$thumb" 2>/dev/null
    fi

    entries+="${name%.*}\x00icon\x1f${thumb}\n"
done < <(find "$WALLPAPER_DIR" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) -print0 | sort -z)

# Show picker
selected=$(echo -e "$entries" | rofi -dmenu -p "" -theme "$HOME/.config/rofi/wallpaper.rasi")

[[ -z "$selected" ]] && exit

# Find full path (match by name without extension)
wall_path=$(find "$WALLPAPER_DIR" -maxdepth 1 -type f | grep -m1 "/${selected}\.")

[[ -z "$wall_path" ]] && exit

# Apply via hyprpaper on all monitors
monitors=$(hyprctl monitors -j | python3 -c "import json,sys; [print(m['name']) for m in json.load(sys.stdin)]")

hyprctl hyprpaper preload "$wall_path"

while IFS= read -r monitor; do
    hyprctl hyprpaper wallpaper "$monitor,$wall_path"
done <<< "$monitors"
