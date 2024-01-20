#!/bin/bash

# Directory containing image files
image_dir="$HOME/.config/backgrounds"

# Transition options
transition_fps=60
transition_type="random"
transition_duration=3

# Get a random image from the directory
random_image=$(find "$image_dir" -type f | shuf -n 1)

if [ -n "$random_image" ]; then
    echo "Displaying: $random_image"
    swww img "$random_image" --transition-fps "$transition_fps" --transition-type "$transition_type" --transition-duration "$transition_duration"
else
    echo "No image files found in $image_dir."
fi

