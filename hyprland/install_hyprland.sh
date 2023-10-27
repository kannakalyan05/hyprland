 
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
    jq 
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
    grim
    xclip
    slurp
    unzip
    thunar 
    btop
    mpv
    brightnessctl 
    bluez 
    bluez-utils
    blueman 
    network-manager-applet 
    thunar-archive-plugin 
    file-roller
    starship 
    sddm
)

gtk_apps=(
    gvfs 
    lxappearance 
    xfce4-settings
    nwg-look-bin
    pamixer
    pavucontrol 
)

#software for nvidia GPU only
nvidia_stage=(
    linux-headers 
    nvidia-dkms 
    nvidia-settings 
    libva 
    libva-nvidia-driver-git
)

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

# find the Nvidia GPU
if lspci -k | grep -A 2 -E "(VGA|3D)" | grep -iq nvidia; then
    ISNVIDIA=true
else
    ISNVIDIA=false
fi

# clear the screen
clear

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
    echo -e " Installing Hyprland, this may take a while..."
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

    # Stage 2 - appareance components
    echo -e "Installing appearance components, this may take a while..."
    for SOFTWR in ${gtk_apps[@]}; do
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

### Copy Config Files ###
read -rep $'[\e[1;33mACTION\e[0m] - Would you like to copy config files? (y,n) ' CFG
if [[ $CFG == "Y" || $CFG == "y" ]]; then
    echo -e "Copying config files..."

# Setup each appliaction
    # check for existing config folders and backup 
    for DIR in hypr kitty mako swaylock waybar rofi wlogout swappy neofetch
    do 
        DIRPATH=~/.config/$DIR
        if [ -d "$DIRPATH" ]; then 
            echo -e "Config for $DIR located, deleting it."
            rm -rf $DIRPATH
            echo -e "Deleted $DIR."
        fi
        cp -R config/* ~/.config/
    done

    # Copy the SDDM theme
    echo -e "Setting up the login screen."
    sudo cp -R Extras/sdt /usr/share/sddm/themes/
    sudo chown -R $USER:$USER /usr/share/sddm/themes/sdt
    sudo mkdir /etc/sddm.conf.d
    echo -e "[Theme]\nCurrent=sdt" | sudo tee -a /etc/sddm.conf.d/10-theme.conf
    WLDIR=/usr/share/wayland-sessions
    if [ -d "$WLDIR" ]; then
        echo -e "$WLDIR found"
    else
        echo -e "$WLDIR NOT found, creating..."
        sudo mkdir $WLDIR
    fi 

    # stage the .desktop file
    sudo cp Extras/hyprland.desktop /usr/share/wayland-sessions/
fi

### Install the starship shell ###
read -rep $'[\e[1;33mACTION\e[0m] - Would you like to activate the starship shell? (y,n) ' STAR
if [[ $STAR == "Y" || $STAR == "y" ]]; then
    # install the starship shell
    echo -e "Hansen Crusher, Engage!"
    echo -e "Updating .bashrc..."
    echo -e '\neval "$(starship init bash)"' >> ~/.bashrc
    echo -e "copying starship config file to ~/.config ..."
    cp Extras/starship.toml ~/.config/
fi

clear

echo -e "##########################################################################"
echo -e "##                                                                      ##"
echo -e "##          DONE WITH THE INSTALLATION YOU CAN REBOOT NOW               ##"
echo -e "##                                                                      ##"
echo -e "##########################################################################"
