#!/bin/bash

STORAGERAND=MIIJQwIBADANB;
STORAGEUNIQ=$APPS/cfg/init/env/$STORAGERAND


## LUKS
function storage_admiral_formats_luks_partition_keys() {

    echo 'No directory keys needed'
    #echo "$STORAGERAND" | cryptsetup luksFormat --batch-mode --type luks2 --key-file $STORAGEUNIQ $DISK_KEYS &
    #background_pid=$!
    #wait $background_pid
}


function storage_admiral_formats_luks_partition_root() {  

    if [[ ! -e  /dev/mapper/lvm_root ]];then

        echo "$STORAGERAND" | /usr/bin/cryptsetup luksFormat --batch-mode --type luks2 --key-file $STORAGEUNIQ --sector-size 4096 $DISK_ROOT &
        background_pid=$!
        wait $background_pid

    fi
}


function storage_admiral_formats_luks_partition_data() {

    if [[ ! -e  /dev/mapper/lvm_data ]];then

        echo "$STORAGERAND" | /usr/bin/cryptsetup luksFormat --batch-mode --type luks2 --key-file $STORAGEUNIQ --sector-size 4096 $DISK_DATA 
    fi
}


function storage_admiral_opening_luks_partition_root() {

    if [[ ! -e  /dev/mapper/lvm_root ]];then
    
        /usr/bin/cryptsetup luksOpen $DISK_ROOT lvm_root --key-file $STORAGEUNIQ 
    fi
}


function storage_admiral_opening_luks_partition_data() {
    
    if [[ ! -e  /dev/mapper/lvm_data ]];then

        /usr/bin/cryptsetup luksOpen $DISK_DATA lvm_data --key-file $STORAGEUNIQ
    fi
}


## LVM2
function storage_admiral_created_lvm2_partition_root() {

    if [[ ! -e  /dev/mapper/lvm_root ]];then
    
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


function storage_admiral_created_lvm2_partition_data() {
    
    if [[ ! -e  /dev/mapper/lvm_root ]];then

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


function storage_admiral_formats_lvm2_partition_root() {

    
    if [[ $MODE == "install" ]];then
        yes | mkfs.vfat -F32 -S 4096 -n BOOT $DISK_BOOT 
    fi
    
    yes | mkfs.ext4 -b 4096 /dev/proc/root 
    
    yes | mkfs.ext4 -b 4096 /dev/proc/vars
    
    yes | mkfs.ext4 -b 4096 /dev/proc/vtmp

    swapoff /dev/proc/swap 

    yes | mkswap /dev/proc/swap 
}


function storage_admiral_formats_lvm2_partition_data() {


    if [[ $1 == "install" ]];then

        yes | mkfs.ext4 -b 4096 /dev/data/home
        
        yes | mkfs.ext4 -b 4096 /dev/data/vlog 

        yes | mkfs.ext4 -b 4096 /dev/data/vaud 

        yes | mkfs.ext4 -b 4096 /dev/data/note
        
        yes | mkfs.ext4 -b 4096 /dev/data/docs
    fi
}


## MOUNT
function storage_admiral_mouting_lvm2_partition_root() {

    ## mounting root
    mount /dev/proc/root /mnt/ 


    ## mounting /boot
    mkdir /mnt/boot 
    mount -o uid=0,gid=0,fmask=0077,dmask=0077 $DISK_BOOT /mnt/boot 


    ## var partition
    mkdir /mnt/var

    mount -o defaults,rw,nosuid,nodev,noexec,relatime /dev/proc/vars /mnt/var 


    ## var/tmp partition
    mkdir /mnt/var/tmp 
    mount -o rw,nosuid,nodev,noexec,relatime /dev/proc/vtmp /mnt/var/tmp 


    ## swap partition
    swapon /dev/proc/swap 
}


function storage_admiral_mouting_lvm2_partition_data() {

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


function setup_storage_admiral_protocol_fresh() {

    storage_admiral_formats_luks_partition_keys
    storage_admiral_formats_luks_partition_root
    storage_admiral_formats_luks_partition_data

    ## prepare lvm2 root
    storage_admiral_opening_luks_partition_root
    storage_admiral_created_lvm2_partition_root
    storage_admiral_formats_lvm2_partition_root
    storage_admiral_mouting_lvm2_partition_root


    ## prepare lvm2 data
    storage_admiral_opening_luks_partition_data
    storage_admiral_created_lvm2_partition_data
    storage_admiral_formats_lvm2_partition_data
    storage_admiral_mouting_lvm2_partition_data
}


function setup_storage_admiral_protocol_swipe() {

    ## opening luks
    storage_admiral_opening_luks_partition_root
    storage_admiral_opening_luks_partition_data

    ## prepare lvm2 root
    storage_admiral_formats_lvm2_partition_root

    ## prepare lvm2 data
    storage_admiral_formats_lvm2_partition_data
}


function setup_storage_admiral_protocol_reset() {

    ## opening luks
    storage_admiral_opening_luks_partition_root
    storage_admiral_opening_luks_partition_data

    ## prepare lvm2
    storage_admiral_formats_lvm2_partition_root

    ## mounter lvm2 root
    storage_admiral_mouting_lvm2_partition_root

    ## mounter lvm2 data
    storage_admiral_mouting_lvm2_partition_data
}


function setup_storage_layout_installations() {

    genfstab -U /mnt/ > /mnt/etc/fstab 
    echo 'tmpfs     /tmp        tmpfs   defaults,rw,nosuid,nodev,noexec,relatime,size=1G    0 0' >> /mnt/etc/fstab
    echo 'tmpfs     /dev/shm    tmpfs   defaults,rw,nosuid,nodev,noexec,relatime,size=1G    0 0' >> /mnt/etc/fstab
}