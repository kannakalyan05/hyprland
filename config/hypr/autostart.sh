#!/bin/bash

restart_waybar() {
  #restart the waybar
  pkill waybar
  waybar &
}

set_current_background() {
    swww img ~/.config/backgrounds/'background-1.jpg'
}

set_current_background
restart_waybar
