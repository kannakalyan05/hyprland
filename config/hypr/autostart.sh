#!/bin/sh

# Other commands from your first script (e.g., setting the background and restarting Waybar)
set_bg() {
  swww img ~/.config/backgrounds/eveningcity.png
}

restart_waybar() {
  pkill waybar
  waybar &
}

sway_idle() {
   swayidle -w timeout 15 'swaylock -f' timeout 20 'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on'

}

set_bg
restart_waybar
sway_idle
set_bg
