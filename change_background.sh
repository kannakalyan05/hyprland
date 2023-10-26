#!/bin/bash

# Define the folder containing the pictures
picture_folder="$HOME/Downloads/backgrounds/"

# Set transition options
transition_fps=60
transition_type="random"
transition_duration=3

while true; do
  # Check if the picture folder exists
  if [ ! -d "$picture_folder" ]; then
    echo "Picture folder does not exist: $picture_folder"
    exit 1
  fi

  # Find all image files in the folder
  pictures=($(find "$picture_folder" -type f -exec file --mime {} \; | grep 'image/' | cut -d: -f1))

  if [ ${#pictures[@]} -eq 0 ]; then
    echo "No image files found in the folder: $picture_folder"
    exit 1
  fi

  random_index=$((RANDOM % ${#pictures[@]}))
  picture="${pictures[$random_index]}"

  # Check if the 'swww' command is available
  if ! command -v swww &> /dev/null; then
    echo "swww command not found. Make sure it is installed and in your PATH."
    exit 1
  fi

  swww img "$picture" --transition-fps $transition_fps --transition-type $transition_type --transition-duration $transition_duration

  sleep 5
done

