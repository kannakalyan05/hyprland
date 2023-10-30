#!/bin/bash

restart_waybar() {
  #restart the waybar
  pkill waybar
  waybar &
}

set_current_background() {
  swww img ~/.config/backgrounds/forest.jpg
}

set_current_background
restart_waybar
