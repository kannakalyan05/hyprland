#!/bin/bash

clear

cd config  # Change the working directory to "config"

read -rep $'[\e[1;33mACTION\e[0m] - Would you like to replace files? (y,n) ' CFG

if [[ $CFG == "Y" || $CFG == "y" ]]; then
  echo -e "Replacing config files..."
  # Check for existing config folders and remove them
  for DIR in hypr backgrounds cava mpd mpv btop ncmpcpp rofi gtk-3.0 kitty mako qt5ct qt6ct neofetch nwg-look swaylock waybar wlogout
  do
    CWD=$(pwd)
    PWDFILE=$CWD/$DIR
    DIRPATH=~/.config/$DIR
    if [ -d "$PWDFILE" ]; then
      echo -e "Config for $PWDFILE located, deleting it."
      rm -rf $PWDFILE
      echo -e "Deleted $PWDFILE."
      cp -R $DIRPATH $PWDFILE
      echo "Completed copying files from $DIRPATH to $PWDFILE"
    else
      echo -e "Something wrong went."
    fi
  done
else
  echo -e "Haven't copied any files"
fi

cd ..
