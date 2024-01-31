 
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
    pipewire-pulse
    pipewire-alsa
    pipewire-jack
)

#the main packages
install_stage=(
    hyprland
    kitty 
    mako 
    waybar
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
    network-manager-applet 
    thunar-archive-plugin 
    file-roller
    starship 
    sddm
    swww 
)

gtk_apps=(
    bluez
    bluez-utils
    blueman
    gvfs
    xdg-user-dirs
    nwg-look-bin
    pamixer
    mtpfs
    gvfs-mtp
    gvfs-gphoto2
    pavucontrol
    ttf-iosevka-nerd
    adwaita-dark-darose
    whitesur-icon-theme
    ttf-fira-code
    noto-fonts-emoji
    eog
)


# function that will test for a package and if not found it will attempt to install it
install_software() {
  # First lets see if the package is there
  if yay -Q $1 &>> /dev/null ; then
    echo -e "$1 is already installed."
  else
    # no package found so installing
    echo "Now installing $1 ."
    yay -S $1 --noconfirm
  fi
}

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
    for DIR in backgrounds hypr kitty mako btop cava swaylock mpd mpv ncmpcpp nwg-look waybar qt5ct qt6ct rofi wlogout neofetch gtk-3.0
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
    echo -e '\neval "$(starship init bash)"\nalias vi="nvim"' >> ~/.bashrc
    source ~/.bashrc
    echo -e "copying starship config file to ~/.config ..."
    cp Extras/starship.toml ~/.config/
    echo "QT_QPA_PLATFORMTHEME=qt5ct" | sudo tee -a /etc/environment
fi

clear

echo -e "##############################################################################################################"
echo -e "##############################################################################################################"
echo -e "###                                                                                                        ###"
echo -e "###                        DONE WITH THE INSTALLATION YOU CAN REBOOT NOW                                   ###"
echo -e "###                                                                                                        ###"
echo -e "##############################################################################################################"
echo -e "##############################################################################################################"
