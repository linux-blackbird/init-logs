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

    echo "$STORAGERAND" | /usr/bin/cryptsetup luksFormat --batch-mode --type luks2 --key-file $STORAGEUNIQ --sector-size 4096 $DISK_ROOT &
    background_pid=$!
    wait $background_pid
}


function storage_admiral_formats_luks_partition_data() {

    echo "$STORAGERAND" | /usr/bin/cryptsetup luksFormat --batch-mode --type luks2 --key-file $STORAGEUNIQ --sector-size 4096 $DISK_DATA 
}


function storage_admiral_opening_luks_partition_root() {
    
    /usr/bin/cryptsetup luksOpen $DISK_ROOT lvm_root --key-file $STORAGEUNIQ 
}


function storage_admiral_opening_luks_partition_data() {
    
    /usr/bin/cryptsetup luksOpen $DISK_DATA lvm_data --key-file $STORAGEUNIQ
}


## LVM2
function storage_admiral_created_lvm2_partition_root() {

    
    /usr/bin/pvcreate /dev/mapper/lvm_root 

    
    /usr/bin/vgcreate proc /dev/mapper/lvm_root 


    yes | /usr/bin/lvcreate -L 20G proc -n root 


    yes | /usr/bin/lvcreate -L 5G proc -n vars 


    yes | /usr/bin/lvcreate -L 1G proc -n vtmp 


    yes | /usr/bin/lvcreate -l100%FREE proc -n swap 
}


function storage_admiral_created_lvm2_partition_data() {
    

    pvcreate /dev/mapper/lvm_data 

    vgcreate data /dev/mapper/lvm_data

    yes | lvcreate -L 20G data -n home 

    yes | lvcreate -L 50G data -n vlog

    yes | lvcreate -L 20G data -n vaud 

    yes | lvcreate -L 20G data -n docs 

    yes | lvcreate -L 20G data -n note 
}


function storage_admiral_formats_lvm2_partition_root() {

    
    yes | mkfs.vfat -F32 -S 4096 -n BOOT /dev/nvme0n1p1 

    
    yes | mkfs.ext4 -b 4096 /dev/proc/root 

    
    yes | mkfs.ext4 -b 4096 /dev/proc/vars

    
    yes | mkfs.ext4 -b 4096 /dev/proc/vtmp

    swapoff /dev/proc/swap 

    yes | mkswap /dev/proc/swap 
}


function storage_admiral_formats_lvm2_partition_data() {

    yes | mkfs.ext4 -b 4096 /dev/data/home
    
    yes | mkfs.ext4 -b 4096 /dev/data/vlog 

    yes | mkfs.ext4 -b 4096 /dev/data/vaud 

    yes | mkfs.ext4 -b 4096 /dev/data/note
    
    yes | mkfs.ext4 -b 4096 /dev/data/docs
   
}


## MOUNT
function storage_admiral_mouting_lvm2_partition_root() {

    ## mounting root
    mount /dev/proc/root /mnt/ 


    ## mounting /boot
    mkdir /mnt/boot 
    mount -o uid=0,gid=0,fmask=0077,dmask=0077 /dev/nvme0n1p1 /mnt/boot 


    ## var partition
    mkdir /mnt/var

    mount -o defaults,rw,nosuid,nodev,noexec,relatime /dev/proc/vars /mnt/var 


    ## var/tmp partition
    mkdir /mnt/var/tmp 
    mount -o rw,nosuid,nodev,noexec,relatime /dev/proc/vtmp /mnt/var/tmp 


    ## var/log partition
    mkdir /mnt/var/log

    mount -o rw,nosuid,nodev,noexec,relatime /dev/data/vlog /mnt/var/log 

    ## var/log/audit partition
    mkdir /mnt/var/log/audit 

    mount -o rw,nosuid,nodev,noexec,relatime /dev/data/vaud /mnt/var/log/audit


    ## srv/http/public partition
    mkdir /mnt/srv/ /mnt/srv/http/ /mnt/srv/http/public/

    mount -o rw,nosuid,nodev,relatime /dev/data/docs /mnt/srv/http/public


    ## srv/http/public partition
    mkdir /mnt/srv/http/intern/

    mount -o rw,nosuid,nodev,relatime /dev/data/note /mnt/srv/http/intern



    ## swap partition
    swapon /dev/proc/swap 
}


function storage_admiral_mouting_lvm2_partition_data() {

    ## mounting /home
    mkdir /mnt/home 

    mount -o rw,nosuid,nodev,noexec,relatime /dev/data/home /mnt/home 


    ## mounting /var/lib/libvirt/images
    mkdir /mnt/var/lib /mnt/var/lib/libvirt /mnt/var/lib/libvirt/images 

    mount /dev/data/host /mnt/var/lib/libvirt/images 


    ## mounting /var/lib/containers
    mkdir /mnt/var/lib/containers 

    mount /dev/data/pods /mnt/var/lib/containers 

}


function setup_storage_admiral_protocol_fresh() {

    storage_admiral_formats_luks_partition_keys
    storage_admiral_formats_luks_partition_root
    storage_admiral_formats_luks_partition_data

    ## prepare lvm2 root
    storage_admiral_opening_luks_partition_root
    storage_admiral_created_lvm2_partition_root
    storage_admiral_formats_lvm2_partition_root

    ## prepare lvm2 data
    storage_admiral_opening_luks_partition_data
    storage_admiral_created_lvm2_partition_data
    storage_admiral_formats_lvm2_partition_data
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