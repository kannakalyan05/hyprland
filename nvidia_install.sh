#!/bin/bash

#software for nvidia GPU only
nvidia_packages=(
    linux-headers 
    nvidia-dkms 
    nvidia-settings 
    libva 
    libva-nvidia-driver-git
)

# clear the screen
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

### Install all of the above pacakges ####
read -rep $'[\e[1;33mACTION\e[0m] - Would you like to install the nvidia packages? (y,n) ' INST
if [[ $INST == "Y" || $INST == "y" ]]; then
  echo -e "Nvidia GPU support setup stage, this may take a while..."
  for SOFTWR in ${nvidia_packages[@]}; do
    install_software $SOFTWR
  done    
  
  # update config
  sudo sed -i 's/MODULES=()/MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)/' /etc/mkinitcpio.conf
  sudo mkinitcpio --config /etc/mkinitcpio.conf --generate /boot/initramfs-custom.img
  echo -e "options nvidia-drm modeset=1" | sudo tee -a /etc/modprobe.d/nvidia.conf
fi

