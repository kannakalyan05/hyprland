#!/bin/bash

# Install the specified fonts
yay -S noto-fonts-emoji ttf-font-awesome ttf-hanazono ttf-indic-otf ttf-jetbrains-mono-nerd ttf-lxgw-wenkai-tc ttf-ms-fonts

# Copy the Icomoon-Feather.ttf file from the source directory to the system fonts directory
sudo cp Extras/Icomoon-Feather.ttf /usr/share/fonts/TTF/

# Refresh the font cache
fc-cache -f -v
