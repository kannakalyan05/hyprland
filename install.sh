#!/bin/bash

# Define the software that would be inbstalled 
#Need some prep work
prep_stage=(
    qt5-wayland 
    qt5ct
    qt6-wayland 
    qt6ct
    qt5-svg
    qt5-quickcontrols2
    qt5-graphicaleffects
    gtk3 
    polkit-gnome 
    pipewire 
    wireplumber 
)

#software for nvidia GPU only
nvidia_stage=(
    linux-headers 
    nvidia-dkms 
    nvidia-settings 
    libva 
    libva-nvidia-driver-git
)

#the main packages
install_stage=(
    kitty 
    mako 
    waybar
    swww 
    swaylock-effects
    swayidle
    rofi
    hyprshot
    wlogout 
    xdg-desktop-portal-hyprland 
    unzip
    thunar 
    btop
    pamixer 
    pavucontrol 
    brightnessctl 
    bluez 
    bluez-utils
    blueman 
    network-manager-applet 
    starship 
    nwg-look-bin
    xfce4-settings
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
    sudo cp Extras/hyprland.desktop /usr/share/wayland-sessions/
}


# find the Nvidia GPU
if lspci -k | grep -A 2 -E "(VGA|3D)" | grep -iq nvidia; then
    ISNVIDIA=true
else
    ISNVIDIA=false
fi

### Install all of the above pacakges ####
read -rep $'[\e[1;33mACTION\e[0m] - Would you like to install the packages? (y,n) ' INST
if [[ $INST == "Y" || $INST == "y" ]]; then

    # Prep Stage - Bunch of needed items
    echo -e "Prep Stage - Installing needed components, this may take a while..."
    for SOFTWR in ${prep_stage[@]}; do
        install_software $SOFTWR 
    done

    # Setup Nvidia if it was found
    if [[ "$ISNVIDIA" == true ]]; then
        echo -e "Nvidia GPU support setup stage, this may take a while..."
        for SOFTWR in ${nvidia_stage[@]}; do
            install_software $SOFTWR
        done
    
        # update config
        sudo sed -i 's/MODULES=()/MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)/' /etc/mkinitcpio.conf
        sudo mkinitcpio --config /etc/mkinitcpio.conf --generate /boot/initramfs-custom.img
        echo -e "options nvidia-drm modeset=1" | sudo tee -a /etc/modprobe.d/nvidia.conf
    fi

    # Install the correct hyprland version
    echo -e "Installing Hyprland, this may take a while..."
    if [[ "$ISNVIDIA" == true ]]; then
        #check for hyprland and remove it so the -nvidia package can be installed
        if yay -Q hyprland &>> /dev/null ; then
            yay -R --noconfirm hyprland
        fi
        install_software hyprland-nvidia
    else
        install_software hyprland
    fi

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

    # Wayland session required files
    wayland_session
fi

starting_stage() {
    mkdir ~/.config/hypr
    cp HyprV/hypr/* ~/.config/hypr/
}

# Done continue with the rest of your system
clear
echo "Completed installing all the files you can reboot now."
