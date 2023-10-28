#!/bin/bash

update_theme() {
    #set the xfce and GTK theme
    xfconf-query -c xsettings -p /Net/IconThemeName -s "Adwaita-dark"
    gsettings set org.gnome.desktop.interface icon-theme "Adwaita-dark"
    xfconf-query -c xsettings -p /Net/ThemeName -s "Adwaita-dark"
    gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
}

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
# update_theme
