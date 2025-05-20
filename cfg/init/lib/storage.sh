#!/bin/bash

STORAGERAND=MIIJQwIBADANB;
STORAGEUNIQ=$PATH/cfg/tmp/init/$STORAGERAND


## LUKS
function storage_admiral_formats_luks_partition_keys() {

    echo 'No directory keys needed'
    #echo "$STORAGERAND" | cryptsetup luksFormat --batch-mode --type luks2 --key-file $STORAGEUNIQ $DISK_KEYS &
    #background_pid=$!
    #wait $background_pid
}


function storage_admiral_formats_luks_partition_root() {  

    echo "$STORAGERAND" | cryptsetup luksFormat --batch-mode --type luks2 --key-file $STORAGEUNIQ --sector-size 4096 $DISK_ROOT &
    background_pid=$!
    wait $background_pid
}


function storage_admiral_formats_luks_partition_data() {

    echo "$STORAGERAND" | cryptsetup luksFormat --batch-mode --type luks2 --key-file $STORAGEUNIQ --sector-size 4096 $DISK_DATA &
    background_pid=$!
    wait $background_pid
}


function storage_admiral_opening_luks_partition_root() {
    
    cryptsetup luksOpen /dev/$DISK_ROOT lvm_root --key-file $STORAGEUNIQ &
    background_pid=$!
    wait $background_pid
}


function storage_admiral_opening_luks_partition_data() {
    
    cryptsetup luksOpen /dev/$DISK_DATA lvm_data --key-file $STORAGEUNIQ &
    background_pid=$!
    wait $background_pid
}


## LVM2
function storage_admiral_created_lvm2_partition_root() {

    
    pvcreate /dev/mapper/lvm_root &
    background_pid=$!
    wait $background_pid

    
    vgcreate proc /dev/mapper/lvm_root &
    background_pid=$!
    wait $background_pid


    yes | lvcreate -L 20G proc -n root &
    background_pid=$!
    wait $background_pid


    yes | lvcreate -L 5G proc -n vars &
    background_pid=$!
    wait $background_pid


    yes | lvcreate -L 1G proc -n vtmp &
    background_pid=$!
    wait $background_pid


    yes | lvcreate -l100%FREE proc -n swap &
    background_pid=$!
    wait $background_pid
}


function storage_admiral_created_lvm2_partition_data() {
    

    pvcreate /dev/mapper/lvm_data &
    background_pid=$!
    wait $background_pid


    vgcreate data /dev/mapper/lvm_data &
    background_pid=$!
    wait $background_pid


    yes | lvcreate -L 20G data -n home &
    background_pid=$!
    wait $background_pid


     yes | lvcreate -L 50G data -n vlog &
    background_pid=$!
    wait $background_pid


    yes | lvcreate -L 20G data -n vaud &
    background_pid=$!
    wait $background_pid

    yes | lvcreate -L 20G data -n docs &
    background_pid=$!
    wait $background_pid


    yes | lvcreate -L 20G data -n note &
    background_pid=$!
    wait $background_pid
}


function storage_admiral_formats_lvm2_partition_root() {

    
    yes | mkfs.vfat -F32 -S 4096 -n BOOT /dev/nvme0n1p1 &
    background_pid=$!
    wait $background_pid

    
    yes | mkfs.ext4 -b 4096 /dev/proc/root &
    background_pid=$!
    wait $background_pid

    
    yes | mkfs.ext4 -b 4096 /dev/proc/vars &
    background_pid=$!
    wait $background_pid

    
    yes | mkfs.ext4 -b 4096 /dev/proc/vtmp &
    background_pid=$!
    wait $background_pid

    
    yes | mkfs.ext4 -b 4096 /dev/proc/docs &
    background_pid=$!
    wait $background_pid


    yes | mkfs.ext4 -b 4096 /dev/proc/note &
    background_pid=$!
    wait $background_pid


    swapoff /dev/proc/swap &
    background_pid=$!
    wait $background_pid

    yes | mkswap /dev/proc/swap &
    background_pid=$!
    wait $background_pid
}


function storage_admiral_formats_lvm2_partition_data() {

    yes | mkfs.ext4 -b 4096 /dev/data/home
    background_pid=$!
    wait $background_pid

    mkfs.xfs -fs size=4096 /dev/data/pods
    background_pid=$!
    wait $background_pid

    mkfs.xfs -fs size=4096 /dev/data/host
    background_pid=$!
    wait $background_pid
}


## MOUNT
function storage_admiral_mouting_lvm2_partition_root() {

    ## mounting root
    mount /dev/proc/root /mnt/ &
    background_pid=$!
    wait $background_pid


    ## mounting /boot
    mkdir /mnt/boot &
    background_pid=$!
    wait $background_pid

    mount -o uid=0,gid=0,fmask=0077,dmask=0077 /dev/nvme0n1p1 /mnt/boot &
    background_pid=$!
    wait $background_pid


    ## var partition
    mkdir /mnt/var &
    background_pid=$!
    wait $background_pid

    mount -o defaults,rw,nosuid,nodev,noexec,relatime /dev/proc/vars /mnt/var &
    background_pid=$!
    wait $background_pid


    ## var/tmp partition
    mkdir /mnt/var/tmp &
    background_pid=$!
    wait $background_pid

    mount -o rw,nosuid,nodev,noexec,relatime /dev/proc/vtmp /mnt/var/tmp &
    background_pid=$!
    wait $background_pid


    ## var/log partition
    mkdir /mnt/var/log &
    background_pid=$!
    wait $background_pid

    mount -o rw,nosuid,nodev,noexec,relatime /dev/data/vlog /mnt/var/log &
    background_pid=$!
    wait $background_pid


    ## var/log/audit partition
    mkdir /mnt/var/log/audit &
    background_pid=$!
    wait $background_pid

    mount -o rw,nosuid,nodev,noexec,relatime /dev/data/vaud /mnt/var/log/audit &
    background_pid=$!
    wait $background_pid


    ## srv/http/public partition
    mkdir /mnt/srv/ /mnt/srv/http/ /mnt/srv/http/public/ &
    background_pid=$!
    wait $background_pid

    mount -o rw,nosuid,nodev,relatime /dev/data/docs /mnt/srv/http/public &
    background_pid=$!
    wait $background_pid


    ## srv/http/public partition
    mkdir /mnt/srv/http/intern/ &
    background_pid=$!
    wait $background_pid

    mount -o rw,nosuid,nodev,relatime /dev/data/note /mnt/srv/http/intern &
    background_pid=$!
    wait $background_pid



    ## swap partition
    swapon /dev/proc/swap &
    background_pid=$!
    wait $background_pid
}


function storage_admiral_mouting_lvm2_partition_data() {

    ## mounting /home
    mkdir /mnt/home & 
    background_pid=$!
    wait $background_pid

    mount -o rw,nosuid,nodev,noexec,relatime /dev/data/home /mnt/home & 
    background_pid=$!
    wait $background_pid


    ## mounting /var/lib/libvirt/images
    mkdir /mnt/var/lib /mnt/var/lib/libvirt /mnt/var/lib/libvirt/images &
    background_pid=$!
    wait $background_pid

    mount /dev/data/host /mnt/var/lib/libvirt/images  &
    background_pid=$!
    wait $background_pid


    ## mounting /var/lib/containers
    mkdir /mnt/var/lib/containers  &
    background_pid=$!
    wait $background_pid

    mount /dev/data/pods /mnt/var/lib/containers  &
    background_pid=$!
    wait $background_pid

}


function setup_storage_admiral_protocol_fresh() {

    storage_admiral_formats_luks_partition_keys
    storage_admiral_formats_luks_partition_root
    storage_admiral_formats_luks_partition_data

    ## prepare lvm2 root
    storage_admiral_created_lvm2_partition_root
    storage_admiral_formats_lvm2_partition_root

    ## prepare lvm2 data
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