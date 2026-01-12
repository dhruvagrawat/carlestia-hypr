#!/bin/bash

WALL_DIR="/home/anto/Dhruv/Walls"
THUMB_DIR="$HOME/.cache/wall-thumbs"

# Start swww daemon if not running
pgrep -x swww-daemon >/dev/null || swww-daemon &

mkdir -p "$THUMB_DIR"

# Generate thumbnails if missing
for img in "$WALL_DIR"/*.{jpg,jpeg,png,webp}; do
    [ -e "$img" ] || continue
    name=$(basename "$img")
    thumb="$THUMB_DIR/$name.png"

    if [ ! -f "$thumb" ]; then
    magick "$img" -resize 500x214^ -gravity center -extent 500x214 "$thumb"

    fi
done

# Build rofi input (icon + label)
SELECTED=$(for img in "$WALL_DIR"/*.{jpg,jpeg,png,webp}; do
    [ -e "$img" ] || continue
    name=$(basename "$img")
    echo -en "$name\x00icon\x1f$THUMB_DIR/$name.png\n"
done | rofi -dmenu -i -show-icons -theme ~/.config/rofi/wallpaper.rasi -p "󰸉 Wallpaper")

[ -z "$SELECTED" ] && exit 0

swww img "$WALL_DIR/$SELECTED" \
  --transition-type grow \
  --transition-duration 1.2
