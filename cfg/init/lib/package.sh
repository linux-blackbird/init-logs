#!/bin/bash

source /init/env/data


MAIN_KERNELS_PACKAGE="linux-hardened linux-firmware mkinitcpio intel-ucode base base-devel"
MAIN_NETWORK_PACKAGE="openssh"
MAIN_SECURED_PAKCAGE="firewalld tang apparmor libpwquality nftables clevis mkinitcpio-nfs-utils luksmeta"
MAIN_STORAGE_PACKAGE="xfsprogs lvm2"
MAIN_TUNNING_PACKAGE="reflector tuned tuned-ppd irqbalance"
MAIN_UTILITY_PACKAGE="git less btop"
MAIN_DEVELOP_PACKAGE="neovim"
MAIN_BACKUPS_PACKAGE="rsync"
MAIN_PLAYERS_PACKAGE=""
MAIN_CONTAIN_PACKAGE=""
MAIN_AUDISYS_PACKAGE=""
MAIN_SERVICE_PACKAGE="nginx"
MAIN_OFFICES_PACKAGE="hugo"
MAIN_BROWSER_PACKAGE=""
MAIN_APSTORE_PACKAGE=""
MAIN_DESKTOP_PACKAGE=""
MAIN_VARIANT_MUEDIAS=""
MAIN_PROFILE_DEVELOP=""
MAIN_PROFILE_SUPPORT=""


AURS_KERNELS_PACKAGE=""
AURS_NETWORK_PACKAGE=""
AURS_SECURED_PAKCAGE="mkinitcpio-clevis-hook aide"
AURS_STORAGE_PACKAGE=""
AURS_TUNNING_PACKAGE=""
AURS_UTILITY_PACKAGE=""
AURS_DEVELOP_PACKAGE=""
AURS_BACKUPS_PACKAGE=""
AURS_PLAYERS_PACKAGE=""
AURS_CONTAIN_PACKAGE=""
AURS_AUDISYS_PACKAGE=""
AURS_SERVICE_PACKAGE=""
AURS_OFFICES_PACKAGE=""
AURS_BROWSER_PACKAGE=""
AURS_APSTORE_PACKAGE=""
AURS_DESKTOP_PACKAGE=""
AURS_PROFILE_MUMEDIA=""
AURS_PROFILE_DEVELOP=""
AURS_PROFILE_SUPPORT=""



### INSTALLATION
function install_package_main_blackbird_basics() {

    pacstrap /mnt/  $MAIN_KERNELS_PACKAGE $MAIN_SECURED_PAKCAGE $MAIN_NETWORK_PACKAGE $MAIN_STORAGE_PACKAGE $MAIN_TUNNING_PACKAGE \
                    $MAIN_UTILITY_PACKAGE $MAIN_DEVELOP_PACKAGE $MAIN_SERVICE_PACKAGE $MAIN_PLAYERS_PACKAGE $MAIN_DESKTOP_PACKAGE \
                    $MAIN_AUDISYS_PACKAGE $MAIN_FILEMAN_PACKAGE $MAIN_OFFICES_PACKAGE $MAIN_BROWSER_PACKAGE $MAIN_APSTORE_PACKAGE
}


function install_package_main_blackbird_variant() {


    if [[ $VARIANT == "multimedia" ]];then
        pacstrap /mnt/  $MAIN_PROFILE_MEDIAS
    fi

    if [[ $VARIANT == "development" ]];then
        pacstrap /mnt/  $MAIN_PROFILE_DEVELS
    fi

    if [[ $VARIANT == "multimedia" ]];then
        pacstrap /mnt/  $MAIN_PROFILE_SUPPOR
    fi
}


function install_package_aurs_blackbird_basics() {

    ## open user permision
    echo 'h3x0r ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/00_lektor &&


    ## aur package manager
    sudo -H -u h3x0r -c "git clone https://aur.archlinux.org/yay /tmp/yay" &&
    sudo -H -u h3x0r -c "makepkg -sric --dir /tmp/yay --noconfirm" &&

    ## register gpg keys
    sudo -H -u h3x0r bash -c "gpg --recv-keys 2BBBD30FAAB29B3253BCFBA6F6947DAB68E7B931" &&
    

    ## install aur package
    sudo -H -u h3x0r -c "yay -S $AURS_KERNELS_PACKAGE $AURS_SECURED_PAKCAGE $AURS_NETWORK_PACKAGE $AURS_STORAGE_PACKAGE $AURS_TUNNING_PACKAGE \
                                $AURS_UTILITY_PACKAGE $AURS_DEVELOP_PACKAGE $AURS_SERVICE_PACKAGE $AURS_PLAYERS_PACKAGE $AURS_DESKTOP_PACKAGE \
                                $AURS_AUDISYS_PACKAGE $AURS_FILEMAN_PACKAGE $AURS_OFFICES_PACKAGE $AURS_BROWSER_PACKAGE $AURS_APSTORE_PACKAGE \
                         --noconfirm" &&


    ## close user permision
    echo 'h3x0r ALL=(ALL:ALL) ALL' > /etc/sudoers.d/00_lektor
}


function install_package_aurs_blackbird_variant() {

    ## open user permision
    echo 'h3x0r ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/00_lektor


    ## install aur package
    if [[ $VARIANT == "multimedia" ]];then

         sudo -H -u h3x0r -c "yay  -S $AURS_PROFILE_MUMEDIA --noconfirm"
    fi

    if [[ $VARIANT == "development" ]];then

        sudo -H -u h3x0r -c "yay  -S $AURS_PROFILE_DEVELOP --noconfirm"
    fi

    if [[ $VARIANT == "multimedia" ]];then

        sudo -H -u h3x0r -c "yay  -S $AURS_PROFILE_SUPPORT --noconfirm"
    fi

    ## close user permision
    echo 'h3x0r ALL=(ALL:ALL) ALL' > /etc/sudoers.d/00_lektor
}



### CONFIGURATION
function config_package_main_blackbird_kernels() {


    echo "cryptdevice=UUID=$(blkid -s UUID -o value /dev/$DISK_ROOT):crypto root=/dev/proc/root" > /etc/cmdline.d/01-boot.conf 
    echo "data UUID=$(blkid -s UUID -o value /dev/$DISK_DATA) none" >> /etc/crypttab 
    mv /boot/intel-ucode.img /boot/vmlinuz-linux-hardened /boot/kernel 
    rm /boot/initramfs-* 

    if [[ $MODE == "install" ]];then
        bootctl --path=/boot/ install 
    fi

    mkinitcpio -P
}


function config_package_main_blackbird_network() {
    systemctl enable sshd 
    systemctl enable systemd-networkd.socket
    systemctl enable systemd-resolved
}


function config_package_main_blackbird_secured() {

    ## firewalld configuration
    systemctl enable firewalld 
    systemctl enable apparmor.service 

    ## tang server
    systemctl enable tangd.socket
   

    ## clevis kernel parameter
    systemctl enable clevis-luks-askpass.path
    echo "ip=$IPADDRRES::10.10.1.1:255.255.255.0::eth0:none nameserver=10.10.1.1" > /etc/cmdline.d/06-nets.conf
}


function config_package_main_blackbird_desktop() {
    echo 'no package registered'
}


function config_package_main_blackbird_storage() {
    echo 'no package registered'
}


function config_package_main_blackbird_tunning() {
    cp /etc/pacman.d/mirrorlist /etc/pacman.d/backupmirror 
    systemctl enable tuned
    systemctl enable irqbalance.service
}


function config_package_main_blackbird_utility() {
    echo 'no package registered'
}


function config_package_main_blackbird_develop() {
    echo 'no package registered'
}


function config_package_main_blackbird_service() {
    ## nginx configuration
    mkdir /etc/nginx/sites-pool
    mkdir /etc/nginx/sites-main
}


function config_package_main_blackbird_players() {
    echo 'no package registered'
}


function config_package_main_blackbird_audisys() {
    echo 'no package registered'
}


function config_package_main_blackbird_fileman() {
    echo 'no package registered'
}


function config_package_main_blackbird_offices() {
    echo 'no package registered'
}


function config_package_main_blackbird_browser() {
    echo 'no package registered'
}


function config_package_main_blackbird_apstore() {
    echo 'no package registered'
}