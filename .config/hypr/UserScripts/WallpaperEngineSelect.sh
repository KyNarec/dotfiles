
#!/bin/bash
# Rofi menu for selecting Wallpaper Engine workshop wallpapers

# Path to Workshop wallpapers
WALL_DIR="$HOME/.local/share/Steam/steamapps/workshop/content/431960"

# Command to run wallpaper engine
RUN_CMD="linux-wallpaperengine --silent --screen-root DP-3 --screen-root HDMI-A-1"

# Rofi command config (you can adjust the .rasi style to make it show image grid)
ROFI_CMD="rofi -dmenu -i -config ~/.config/rofi/config-wallpaper.rasi"

# Collect workshop folders (only those with a preview.jpg)
FOLDERS=($(find "$WALL_DIR" -mindepth 1 -maxdepth 1 -type d | sort))

# Build Rofi menu dynamically
menu() {
  for folder in "${FOLDERS[@]}"; do
    name=$(basename "$folder")

    # Check for preview image (.jpg or .png)
    for ext in jpg png gif; do
      preview_candidate="$folder/preview.$ext"
      if [[ -f "$preview_candidate" ]]; then
        preview="$preview_candidate"
        break
      fi
    done

    # Show folder name with preview icon if available
    if [[ -n "$preview" ]]; then
      printf "%s\x00icon\x1f%s\n" "$name" "$preview"
    else
      printf "%s\n" "$name"
    fi
  done
}

# If Rofi is already open, close it (to prevent multiple instances)
if pidof rofi > /dev/null; then
  pkill rofi
  exit 0
fi

# Get user choice
choice=$(menu | $ROFI_CMD)

# Exit if no selection
[[ -z "$choice" ]] && exit 0

# Kill any previously running linux-wallpaperengine processes
if pgrep -x "linux-wallpaper" > /dev/null; then
  echo "Stopping old wallpaperengine processes..."
  pkill -x linux-wallpaper
  sleep 0.5  # small delay to ensure clean shutdown
fi

# Find chosen folder
for folder in "${FOLDERS[@]}"; do
  if [[ "$(basename "$folder")" == "$choice" ]]; then
    echo "Launching wallpaper: $folder"
    $RUN_CMD "$folder"
    exit 0
  fi
done

# If folder not found (edge case)
echo "Wallpaper not found: $choice"
exit 1
