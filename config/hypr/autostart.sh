#!/bin/sh

# Other commands from your first script (e.g., setting the background and restarting Waybar)
set_current_background() {
  swww img ~/.config/backgrounds/forest.jpg
}

restart_waybar() {
  pkill waybar
  waybar &
}

sway_idle() {
   swayidle -w timeout 300 'swaylock -f' timeout 360 'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on'
}

restart_waybar
sway_idle
set_current_background
