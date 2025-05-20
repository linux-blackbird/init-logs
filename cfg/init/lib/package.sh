


MAIN_KERNELS_PACKAGE="linux-hardened linux-firmware mkinitcpio intel-ucode base base-devel"
MAIN_NETWORK_PACKAGE="openssh"
MAIN_SECURED_PAKCAGE="firewalld tang apparmor libpwquality nftables"
MAIN_STORAGE_PACKAGE="xfsprogs lvm2 clevis mkinitcpio-nfs-utils luksmeta"
MAIN_TUNNING_PACKAGE="reflector tuned tuned-ppd irqbalance"
MAIN_UTILITY_PACKAGE="git less btop"
MAIN_DEVELOP_PACKAGE="neovim"
MAIN_BACKUPS_PACKAGE="rsync"
MAIN_VIRTUAL_PACKAGE=""
MAIN_PLAYERS_PACKAGE=""
MAIN_CONTAIN_PACKAGE=""
MAIN_AUDISYS_PACKAGE=""
MAIN_FILEMAN_PACKAGE=""
MAIN_OFFICES_PACKAGE="hugo"
MAIN_BROWSER_PACKAGE=""
MAIN_APSTORE_PACKAGE=""
MAIN_DESKTOP_PACKAGE=""


MAIN_PROFILE_MEDIAS=""
MAIN_PROFILE_DEVELS=""
MAIN_PROFILE_SUPPOR=""

AURS_PACKAGE_ALLVAR=""
AURS_PROFILE_MEDIAS=""
AURS_PROFILE_DEVELS=""
AURS_PROFILE_SUPPOR=""


### INSTALLATION

function install_package_main_admiral_basics() {

    pacstrap /mnt/  $MAIN_KERNELS_PACKAGE $MAIN_SECURED_PAKCAGE $MAIN_NETWORK_PACKAGE $MAIN_STORAGE_PACKAGE $MAIN_TUNNING_PACKAGE \
                    $MAIN_UTILITY_PACKAGE $MAIN_DEVELOP_PACKAGE $MAIN_VIRTUAL_PACKAGE $MAIN_PLAYERS_PACKAGE $MAIN_CONTAIN_PACKAGE \
                    $MAIN_AUDISYS_PACKAGE $MAIN_FILEMAN_PACKAGE $MAIN_OFFICES_PACKAGE $MAIN_BROWSER_PACKAGE $MAIN_APSTORE_PACKAGE \
                    $MAIN_DESKTOP_PACKAGE
}


function install_package_main_admiral_medias() {

    pacstrap /mnt/  $MAIN_PROFILE_MEDIAS
}


function install_package_main_admiral_devels() {

    pacstrap /mnt/  $MAIN_PROFILE_DEVELS
}


function install_package_main_admiral_suppor() {

    pacstrap /mnt/  $MAIN_PROFILE_SUPPOR
}


function install_package_aurs_admiral_aurman() {

    echo 'h3x0r ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/00_lektor
    sudo -H -u lektor bash -c 'git clone https://aur.archlinux.org/yay /tmp/yay'
    sudo -H -u lektor bash -c 'makepkg -sric --dir /tmp/yay --noconfirm'
    echo 'h3x0r ALL=(ALL:ALL) ALL' > /etc/sudoers.d/00_lektor
}


function install_package_aurs_admiral_basics() {

    echo 'h3x0r ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/00_lektor
    sudo -H -u lektor bash -c "yay -S $AURS_PACKAGE_ALLVAR --noconfirm && yay -Yc"
    echo 'h3x0r ALL=(ALL:ALL) ALL' > /etc/sudoers.d/00_lektor
}


function install_package_aurs_admiral_medias() {

    echo 'h3x0r ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/00_lektor
    sudo -H -u lektor bash -c "yay -S $AURS_PROFILE_MEDIAS --noconfirm && yay -Yc"
    echo 'h3x0r ALL=(ALL:ALL) ALL' > /etc/sudoers.d/00_lektor

}


function install_package_aurs_admiral_devels() {
    
    echo 'h3x0r ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/00_lektor
    sudo -H -u lektor bash -c "yay -S $AURS_PROFILE_DEVELS --noconfirm && yay -Yc"
    echo 'h3x0r ALL=(ALL:ALL) ALL' > /etc/sudoers.d/00_lektor
}


function install_package_aurs_admiral_suppor() {
    
    echo 'h3x0r ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/00_lektor
    sudo -H -u lektor bash -c "yay -S $AURS_PROFILE_SUPPOR --noconfirm && yay -Yc"
    echo 'h3x0r ALL=(ALL:ALL) ALL' > /etc/sudoers.d/00_lektor
}



### CONFIGURATION

function config_package_main_admiral_kernels() {

}


function config_package_main_admiral_desktop() {
    
}


function config_package_main_admiral_network() {

}


function config_package_main_admiral_desktop() {
    
}


function config_package_main_admiral_storage() {

}


function config_package_main_admiral_tunning() {

}


function config_package_main_admiral_utilities() {

}


function config_package_main_admiral_develop() {

}


function config_package_main_admiral_virtual() {

}


function config_package_main_admiral_players() {

}


function config_package_main_admiral_containers() {

}


function config_package_main_admiral_audisys() {

}


function config_package_main_admiral_fileman() {

}


function config_package_main_admiral_offices() {

}


function config_package_main_admiral_browser() {

}


function config_package_main_admiral_apstore() {

}


function config_package_main_admiral_profile() {

}


function config_package_main_admiral_profile_medias() {

}


function config_package_main_admiral_profile_devels() {

}


function config_package_main_admiral_profile_suppor() {

}


function config_package_main_admiral_aurs() {

}


function config_package_main_admiral_aurs_medias() {

}


function config_package_main_admiral_aurs_devels() {

}


function config_package_main_admiral_aurs_suppor() {

}
