#!/bin/bash

# Define the software that would be inbstalled 
#Need some prep work
prep_stage=(
    polkit-gnome 
    pipewire 
    pipewire-pulse
    wireplumber 
)


#the main packages
install_stage=(
    hyprland
    kitty 
    waybar
    xdg-desktop-portal-hyprland 
    unzip
    thunar 
    btop
    brightnessctl 
    bluez 
    bluez-utils
    blueman 
    network-manager-applet 
    starship
    sddm
)

# Clear the screen
clear

# function that will test for a package and if not found it will attempt to install it
install_software() {
  # First lets see if the package is there
  if yay -Q $1 &>> /dev/null ; then
    echo -e "$1 is already installed."
  else
    # no package found so installing
    echo "Now installing $1 ."
    yay -S $1 
  fi
}

wayland_session() {
    WLDIR=/usr/share/wayland-sessions
    if [ -d "$WLDIR" ]; then
        echo -e "$WLDIR found"
    else
        echo -e "$WLDIR NOT found, creating..."
        sudo mkdir $WLDIR
    fi 
    # stage the .desktop file
    sudo cp ../Extras/hyprland.desktop /usr/share/wayland-sessions/
}


### Install all of the above pacakges ####
read -rep $'[\e[1;33mACTION\e[0m] - Would you like to install the packages? (y,n) ' INST
if [[ $INST == "Y" || $INST == "y" ]]; then

    # Prep Stage - Bunch of needed items
    echo -e "Prep Stage - Installing needed components, this may take a while..."
    for SOFTWR in ${prep_stage[@]}; do
        install_software $SOFTWR 
    done

    # Stage 1 - main components
    echo -e "Installing main components, this may take a while..."
    for SOFTWR in ${install_stage[@]}; do
        install_software $SOFTWR 
    done

    # Start the bluetooth service
    echo -e "Starting the Bluetooth Service..."
    sudo systemctl enable --now bluetooth.service
    sleep 2

    # Enable the sddm login manager service
    echo -e "Enabling the SDDM Service..."
    sudo systemctl enable sddm
    sleep 2
    
    # Clean out other portals
    echo -e "Cleaning out conflicting xdg portals..."
    yay -R --noconfirm xdg-desktop-portal-gnome xdg-desktop-portal-gtk

fi

# Wayland session required files
wayland_session

# Done continue with the rest of your system
clear
echo "Completed installing all the files you can reboot now."