#!/bin/bash

USERNAME='florian'
SOURCE_FOLDER="$(pwd)/dotfiles/kvm"
HOME_FOLDER="/home/$USERNAME"

if [ $EUID -ne 0 ]; then
	echo "This program must run as root to function." 
	exit 1
fi

echo "This will install and configure libvirt."
pacman -S libvirt libvirt-glib libvirt-python virt-install virt-manager qemu qemu-arch-extra ovmf vde2 dnsmasq bridge-utils openbsd-netcat swtpm --noconfirm

echo "systemctl enable libvirtd"
systemctl enable libvirtd

echo "systemctl start libvirtd"
systemctl start libvirtd

echo "mv /etc/libvirt/libvirtd.conf /etc/libvirt/libvirtd.conf.old"
mv /etc/libvirt/libvirtd.conf /etc/libvirt/libvirtd.conf.old

echo "Adding $USERNAME to kvm and libvirt groups..."
gpasswd -M $USERNAME kvm
gpasswd -M $USERNAME libvirt

echo "cp $SOURCE_FOLDER/libvirtd.conf /etc/libvirt"
cp "$SOURCE_FOLDER/libvirtd.conf" /etc/libvirt
echo "libvirt has been successfully configured!"

echo "cp /etc/libvirt/qemu.conf /etc/libvirt/qemu.conf.old"
cp /etc/libvirt/qemu.conf /etc/libvirt/qemu.conf.old

echo "cp $SOURCE_FOLDER/libvirt/qemu.conf /etc/libvirt"
cp $SOURCE_FOLDER/libvirt/qemu.conf /etc/libvirt

echo "cp -R $SOURCE_FOLDER/libvirt/hooks /etc/libvirt"
cp -R $SOURCE_FOLDER/libvirt/hooks /etc/libvirt

echo "systemctl restart libvirtd"
systemctl restart libvirtd

echo "QEMU has been successfully configured!"
