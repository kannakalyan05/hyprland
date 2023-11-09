#!/bin/sh

# Other commands from your first script (e.g., setting the background and restarting Waybar)
set_bg() {
  swww img ~/.config/backgrounds/forest.jpg
}

restart_waybar() {
  pkill waybar
  waybar &
}

sway_idle() {
   swayidle -w timeout 300 'swaylock -f' timeout 310 'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on'

}

set_bg
restart_waybar
sway_idle
set_bg
