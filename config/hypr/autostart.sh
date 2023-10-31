#!/bin/sh

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
