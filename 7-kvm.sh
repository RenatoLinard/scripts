#!/bin/bash
#  _  ____     ____  __  
# | |/ /\ \   / /  \/  | 
# | ' /  \ \ / /| |\/| | 
# | . \   \ V / | |  | | 
# |_|\_\   \_/  |_|  |_| 
#                        
#  
# by Stephan Raabe (2023) 
# ----------------------------------------------------- 

# ------------------------------------------------------
# Install Script for Libvirt
# ------------------------------------------------------

read -p "Do you want to start? " s
echo "START KVM/QEMU-full/VIRT MANAGER INSTALLATION..."

# ------------------------------------------------------
# Install Packages
# ------------------------------------------------------
sudo pacman -Rdd iptables --noconfirm
sudo pacman -S --noconfirm --needed iptables-nft
sudo pacman -S --noconfirm --needed ebtables 
sudo pacman -S --noconfirm --needed nftables 

sudo pacman -S --noconfirm --needed qemu-full
sudo pacman -S --noconfirm --needed virt-manager
sudo pacman -S --noconfirm --needed virt-viewer
sudo pacman -S --noconfirm --needed dnsmasq
sudo pacman -S --noconfirm --needed vde2
sudo pacman -S --noconfirm --needed bridge-utils
sudo pacman -S --noconfirm --needed ovmf
sudo pacman -S --noconfirm --needed edk2-ovmf
sudo pacman -S --noconfirm --needed swtpm

#sudo pacman -S --noconfirm --needed spice-vdagent 
#sudo pacman -S --noconfirm --needed xf86-video-qxl

sudo pacman -S --noconfirm --needed dmidecode

# ------------------------------------------------------
# Edit libvirtd.conf
# ------------------------------------------------------
echo "Manual steps required:"
echo "Open sudo vim /etc/libvirt/libvirtd.conf:"
echo 'Remove # at the following lines: unix_sock_group = "libvirt" and unix_sock_rw_perms = "0770"'
read -p "Press any key to open libvirtd.conf: " c
sudo vim /etc/libvirt/libvirtd.conf
sudo echo 'log_filters="3:qemu 1:libvirt"' >> /etc/libvirt/libvirtd.conf
sudo echo 'log_outputs="2:file:/var/log/libvirt/libvirtd.log"' >> /etc/libvirt/libvirtd.conf

# ------------------------------------------------------
# Add user to the group
# ------------------------------------------------------
sudo usermod -a -G kvm,libvirt $(whoami)

# ------------------------------------------------------
# Enable services
# ------------------------------------------------------
sudo systemctl enable libvirtd
sudo systemctl start libvirtd

# ------------------------------------------------------
# Edit qemu.conf
# ------------------------------------------------------
echo "Manual steps required:"
echo "Open sudo vim /etc/libvirt/qemu.conf"
echo "Uncomment and add your user name to user and group."
echo 'user = "your username"'
echo 'group = "your username"'
read -p "Press any key to open qemu.conf: " c
sudo vim /etc/libvirt/qemu.conf

# ------------------------------------------------------
# Restart Services
# ------------------------------------------------------
sudo systemctl restart libvirtd

# ------------------------------------------------------
# Autostart Network
# ------------------------------------------------------
sudo virsh net-autostart default

echo "Please restart your system with reboot."

