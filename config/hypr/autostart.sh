#!/bin/sh

if [ -f "/usr/bin/swayidle" ]; then
  echo "swayidle is installed."
  swayidle -w timeout 300 'swaylock -f' timeout 360 'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on'
else
  echo "swayidle is not installed."
fi;

# Other commands from your first script (e.g., setting the background and restarting Waybar)
set_current_background() {
  swaymsg output '*' bg-image ~/.config/backgrounds/forest.jpg
}

restart_waybar() {
  pkill waybar
  waybar &
}

set_current_background
restart_waybar