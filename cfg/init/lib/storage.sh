#!/bin/bash

STORAGERAND=MIIJQwIBADANB
STORAGEUNIQ=$APPS/cfg/init/env/$STORAGERAND


## LUKS
function storage_blackbird_formats_luks_partition_keys() {

    if [[ -e /dev/mapper/lvm_keys ]]&&[[ ! -z $DISK_KEYS ]];then
        swapoff /dev/proc/swap 
        yes | lvremove /dev/proc/*
        yes | vgremove proc
        yes | pvremove /dev/mapper/lvm_root  
        yes | /usr/bin/cryptsetup luksClose /dev/mapper/lvm_root   

        echo $STORAGERAND | /usr/bin/cryptsetup luksFormat --batch-mode --type luks2 --sector-size 4096 $DISK_KEYS
        echo $STORAGERAND | /usr/bin/cryptsetup luksAddKey --batch-mode --type luks2 --key-file $STORAGEUNIQ $DISK_KEYS
    else
        echo 'No directory keys needed'
    fi
}


function storage_blackbird_formats_luks_partition_root() {  

    if [[ -e /dev/mapper/lvm_root ]];then
        swapoff /dev/proc/swap &&
        yes | lvremove /dev/proc/* &&
        yes | vgremove proc
        yes | pvremove /dev/mapper/lvm_root  
        yes | /usr/bin/cryptsetup luksClose /dev/mapper/lvm_root   
    fi

    echo $STORAGERAND | /usr/bin/cryptsetup luksFormat --batch-mode --type luks2 --sector-size 4096 $DISK_ROOT
    echo $STORAGERAND | /usr/bin/cryptsetup luksAddKey --batch-mode --key-file $STORAGEUNIQ $DISK_ROOT
}


function storage_blackbird_formats_luks_partition_data() {

     if [[ -e  /dev/mapper/lvm_data ]];then
        yes | lvremove /dev/data/* &&
        yes | vgremove data &&
        yes | pvremove /dev/mapper/lvm_data    
        yes | /usr/bin/cryptsetup luksClose /dev/mapper/lvm_data   
    fi
    echo $STORAGERAND | /usr/bin/cryptsetup luksFormat --batch-mode --type luks2 --sector-size 4096 $DISK_DATA
    echo $STORAGERAND | /usr/bin/cryptsetup luksFormat --batch-mode --key-file $STORAGEUNIQ $DISK_DATA 
}


function storage_blackbird_opening_luks_partition_root() {

    if [[ ! -e /dev/mapper/lvm_root ]];then
    
        /usr/bin/cryptsetup luksOpen $DISK_ROOT lvm_root --key-file $STORAGEUNIQ 
    fi
}


function storage_blackbird_opening_luks_partition_data() {
    
    if [[ ! -e  /dev/mapper/lvm_data ]];then

        /usr/bin/cryptsetup luksOpen $DISK_DATA lvm_data --key-file $STORAGEUNIQ
    fi
}


## LVM2
function storage_blackbird_created_lvm2_partition_root() {

    if [[ $MODE == "install" ]];then
    
        /usr/bin/pvcreate /dev/mapper/lvm_root 
        /usr/bin/vgcreate proc /dev/mapper/lvm_root 
    fi

    if [[ ! -e /dev/proc/root ]];then

        yes | /usr/bin/lvcreate -L 20G proc -n root 
    fi

    if [[ ! -e /dev/proc/vars ]];then

        yes | /usr/bin/lvcreate -L 5G proc -n vars 
    fi

    if [[ ! -e /dev/proc/vtmp ]];then

        yes | /usr/bin/lvcreate -L 1G proc -n vtmp 
    fi

    if [[ ! -e /dev/proc/swap ]];then

        yes | /usr/bin/lvcreate -l100%FREE proc -n swap
    fi
}


function storage_blackbird_created_lvm2_partition_data() {
    

    if [[ $MODE == "install" ]];then

        pvcreate /dev/mapper/lvm_data 
        vgcreate data /dev/mapper/lvm_data
    fi

    if [[ ! -e /dev/data/home ]];then

        yes | lvcreate -L 20G data -n home 
    fi

    if [[ ! -e /dev/data/vlog ]];then

        yes | lvcreate -L 50G data -n vlog
    fi

    if [[ ! -e /dev/data/vaud ]];then

        yes | lvcreate -L 20G data -n vaud
    fi

    if [[ ! -e /dev/data/docs ]];then

        yes | lvcreate -L 20G data -n docs
    fi

    if [[ ! -e /dev/data/note ]];then

        yes | lvcreate -L 20G data -n note 
    fi
}


function storage_blackbird_formats_lvm2_partition_root() {

    if [[ $MODE == "install" ]];then
        yes | mkfs.vfat -F32 -S 4096 -n BOOT $DISK_BOOT 
    fi
    
    yes | mkfs.ext4 -b 4096 /dev/proc/root 
    
    yes | mkfs.ext4 -b 4096 /dev/proc/vars
    
    yes | mkfs.ext4 -b 4096 /dev/proc/vtmp

    swapoff /dev/proc/swap 

    yes | mkswap /dev/proc/swap 
}


function storage_blackbird_formats_lvm2_partition_data() {


    if [[ $MODE == "install" ]];then

        yes | mkfs.ext4 -b 4096 /dev/data/home
        
        yes | mkfs.ext4 -b 4096 /dev/data/vlog 

        yes | mkfs.ext4 -b 4096 /dev/data/vaud 

        yes | mkfs.ext4 -b 4096 /dev/data/note
        
        yes | mkfs.ext4 -b 4096 /dev/data/docs
    fi
}


## MOUNT
function storage_blackbird_mouting_lvm2_partition_root() {

    ## mounting root
    mount /dev/proc/root /mnt/ 


    ## mounting /boot
    mkdir /mnt/boot 
    mount -o uid=0,gid=0,fmask=0077,dmask=0077 $DISK_BOOT /mnt/boot 
    rm -fr /mnt/boot/* > /dev/null


    ## var partition
    mkdir /mnt/var
    mount -o defaults,rw,nosuid,nodev,noexec,relatime /dev/proc/vars /mnt/var 


    ## var/tmp partition
    mkdir /mnt/var/tmp 
    mount -o rw,nosuid,nodev,noexec,relatime /dev/proc/vtmp /mnt/var/tmp 


    ## swap partition
    swapon /dev/proc/swap 
}


function storage_blackbird_mouting_lvm2_partition_data() {

    ## mounting /home

    if [[ ! -d /mnt/home  ]];then
        mkdir /mnt/home 
    fi
    mount -o rw,nosuid,nodev,noexec,relatime /dev/data/home /mnt/home 


    ## var/log partition
    if [[ ! -d /mnt/var/log  ]];then
        mkdir /mnt/var/log
    fi
    mount -o rw,nosuid,nodev,noexec,relatime /dev/data/vlog /mnt/var/log 

    ## var/log/audit partition
    if [[ ! -d /mnt/var/log/audit  ]];then
        mkdir /mnt/var/log/audit 
    fi
    mount -o rw,nosuid,nodev,noexec,relatime /dev/data/vaud /mnt/var/log/audit


    ## srv/http/public partition
    if [[ ! -d /mnt/srv/http/public/  ]];then
        mkdir /mnt/srv/ /mnt/srv/http/ /mnt/srv/http/public/
    fi
    mount -o rw,nosuid,nodev,relatime /dev/data/docs /mnt/srv/http/public


    ## srv/http/public partition
    if [[ ! -d /mnt/srv/http/intern/  ]];then
        mkdir /mnt/srv/http/intern/
    fi
    mount -o rw,nosuid,nodev,relatime /dev/data/note /mnt/srv/http/intern
}


function setup_storage_blackbird_protocol_fresh() {

    storage_blackbird_formats_luks_partition_keys
    storage_blackbird_formats_luks_partition_root
    storage_blackbird_formats_luks_partition_data

    ## prepare lvm2 root
    storage_blackbird_opening_luks_partition_root
    storage_blackbird_created_lvm2_partition_root
    storage_blackbird_formats_lvm2_partition_root
    storage_blackbird_mouting_lvm2_partition_root


    ## prepare lvm2 data
    storage_blackbird_opening_luks_partition_data
    storage_blackbird_created_lvm2_partition_data
    storage_blackbird_formats_lvm2_partition_data
    storage_blackbird_mouting_lvm2_partition_data
}


function setup_storage_blackbird_protocol_swipe() {

    ## opening luks
    storage_blackbird_opening_luks_partition_root
    storage_blackbird_opening_luks_partition_data

    ## prepare lvm2 root
    storage_blackbird_formats_lvm2_partition_root

    ## prepare lvm2 data
    storage_blackbird_formats_lvm2_partition_data
}


function setup_storage_blackbird_protocol_reset() {

    ## opening luks
    storage_blackbird_opening_luks_partition_root
    storage_blackbird_opening_luks_partition_data

    ## prepare lvm2 root
    storage_blackbird_formats_lvm2_partition_root
    storage_blackbird_mouting_lvm2_partition_root
    

    ## prepare lvm2 data
    storage_blackbird_mouting_lvm2_partition_data
}


function setup_storage_layout_installations() {

    genfstab -U /mnt/ > /mnt/etc/fstab 
    echo 'tmpfs     /tmp        tmpfs   defaults,rw,nosuid,nodev,noexec,relatime,size=1G    0 0' >> /mnt/etc/fstab
    echo 'tmpfs     /dev/shm    tmpfs   defaults,rw,nosuid,nodev,noexec,relatime,size=1G    0 0' >> /mnt/etc/fstab
}