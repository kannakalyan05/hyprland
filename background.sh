#!/bin/bash
background_dir="~/.config/backgrounds"
image_location=$(find "$background_dir" -type f | shuf -n 1)
swww -i "$image_location" --transition-fps 60 --transition-type random --transition-duration 3

