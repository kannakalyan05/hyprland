#!/bin/sh

# Other commands from your first script (e.g., setting the background and restarting Waybar)
set_current_background() {
  swww img ~/.config/backgrounds/forest.jpg
}

restart_waybar() {
  pkill waybar
  waybar &
}

set_current_background
restart_waybar
