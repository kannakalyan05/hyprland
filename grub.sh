#!/bin/bash

sudo rm -rf /boot/grub/themes/starfield
sudo mkdir /boot/grub/themes/CyberEXS
sudo git clone https://github.com/HenriqueLopes42/themeGrub.CyberEXS.git /boot/grub/themes/CyberEXS
echo 'GRUB_THEME="/boot/grub/themes/CyberEXS/theme.txt"' | sudo tee -a /etc/default/grub
reboot_option='menuentry "Reboot" {
    reboot
}'
shutdown_option='menuentry "Shut Down" {
    halt
}'
echo "$reboot_option" | sudo tee -a /etc/grub.d/40_custom
echo "$shutdown_option" | sudo tee -a /etc/grub.d/40_custom
if [ -f /boot/grub/grub.cfg ]; then
    sudo grub-mkconfig -o /boot/grub/grub.cfg
else
    echo "grub.cfg not found. Please update it manually."
fi
