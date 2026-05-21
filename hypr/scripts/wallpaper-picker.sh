#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/Bilder/Wallpapers"
CACHE_DIR="$HOME/.cache/rofi-wallpaper"
THUMB_SIZE="300x300"
HYPRPAPER_CONF="$HOME/.config/hypr/hyprpaper.conf"
HYPRLOCK_WALL="$WALLPAPER_DIR/wallpaper.png"

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
done < <(find "$WALLPAPER_DIR" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) -not -name "wallpaper.png" -print0 | sort -z)

# Show picker
selected=$(echo -e "$entries" | rofi -dmenu -p "" -theme "$HOME/.config/rofi/wallpaper.rasi")

[[ -z "$selected" ]] && exit

# Find full path (match by name without extension)
wall_path=$(find "$WALLPAPER_DIR" -maxdepth 1 -type f | grep -m1 "/${selected}\.")

[[ -z "$wall_path" ]] && exit

# 1. Apply via hyprpaper on all monitors (live)
hyprctl hyprpaper preload "$wall_path"
monitors=$(hyprctl monitors -j | python3 -c "import json,sys; [print(m['name']) for m in json.load(sys.stdin)]")
while IFS= read -r monitor; do
    hyprctl hyprpaper wallpaper "$monitor,$wall_path"
done <<< "$monitors"

# 2. Persist: update hyprpaper.conf
cat > "$HYPRPAPER_CONF" <<EOF
splash = false

wallpaper {
    monitor =
    path = $wall_path
    fit_mode = cover
}
EOF

# 3. hyprlock: wallpaper.png -> selected wallpaper (hyprlock.conf uses this path)
ln -sf "$wall_path" "$HYPRLOCK_WALL"

# 4. SDDM: write wallpaper to theme backgrounds dir via sudo helper
sudo /usr/local/bin/sddm-set-wallpaper "$wall_path"