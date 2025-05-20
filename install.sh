#!/bin/bash
DURS=$(pwd)
source $DURS/init-logs/env

if [[ -d /mnt/boot ]];then
    umount -R /mnt
fi


### TECHNICAL

if [[ $1 == "install" ]];then

    ### ADMINISTRATOR

    cryptsetup luksFormat /dev/sda2


    cryptsetup luksFormat /dev/sda3


    cryptsetup luksOpen /dev/sda2 lvm_root


    cryptsetup luksOpen /dev/sda3 lvm_data 


    pvcreate /dev/mapper/lvm_root &
    pid=$!
    wait $pid

    vgcreate proc /dev/mapper/lvm_root &
    pid=$!
    wait $pid

    yes | lvcreate -L 20G proc -n root &
    pid=$!
    wait $pid

    yes | lvcreate -L 5G proc -n vars &
    pid=$!
    wait $pid

    yes | lvcreate -L 1G proc -n vtmp &
    pid=$!
    wait $pid

    yes | lvcreate -l100%FREE proc -n swap &
    pid=$!
    wait $pid

    pvcreate /dev/mapper/lvm_data &
    pid=$!
    wait $pid

    vgcreate data /dev/mapper/lvm_data &
    pid=$!
    wait $pid

    yes | lvcreate -L 10G data -n home &
    pid=$!
    wait $pid

    yes | lvcreate -L 50G data -n vlog &
    pid=$!
    wait $pid

    yes | lvcreate -L 20G data -n vaud &
    pid=$!
    wait $pid

    yes | lvcreate -L 10G data -n docs &
    pid=$!
    wait $pid

    yes | lvcreate -L 10G data -n note &
    pid=$!
    wait $pid
fi


## FORMAT ROOT


yes | mkfs.vfat -F32 -S 4096 -n BOOT /dev/sda1 &
pid=$!
wait $pid

yes | mkfs.ext4 -b 4096 /dev/proc/root &
pid=$!
wait $pid

yes | mkfs.ext4 -b 4096 /dev/proc/vars &
pid=$!
wait $pid

yes | mkfs.ext4 -b 4096 /dev/proc/vtmp &
pid=$!
wait $pid

yes | mkswap /dev/proc/swap &
pid=$!
wait $pid


## FORMAT DATA

if [[ $1 == "install" ]];then 

    yes | mkfs.ext4 -b 4096 /dev/data/home &
    forma1=$!
    wait $form1
    
    yes | mkfs.ext4 -b 4096 /dev/data/vlog &
    form2=$!
    wait $form2

    yes | mkfs.ext4 -b 4096 /dev/data/vaud &
    form3=$!
    wait $form3

    yes | mkfs.ext4 -b 4096 /dev/data/docs &
    form4=$!
    wait $form4

    yes | mkfs.ext4 -b 4096 /dev/data/note &
    form5=$!
    wait $form5
fi


mount /dev/proc/root /mnt/ 

mkdir /mnt/boot && mount -o uid=0,gid=0,fmask=0077,dmask=0077 /dev/sda1 /mnt/boot

mkdir /mnt/var && mount -o defaults,rw,nosuid,nodev,noexec,relatime /dev/proc/vars /mnt/var 

mkdir /mnt/var/tmp && mount -o rw,nosuid,nodev,noexec,relatime /dev/proc/vtmp /mnt/var/tmp &

swapon /dev/proc/swap &

mkdir /mnt/home && mount -o rw,nosuid,nodev,noexec,relatime /dev/data/home /mnt/home &

mkdir /mnt/var/log && mount -o rw,nosuid,nodev,noexec,relatime /dev/data/vlog /mnt/var/log &

mkdir /mnt/var/log/audit && mount -o rw,nosuid,nodev,noexec,relatime /dev/data/vaud /mnt/var/log/audit &

mkdir /mnt/srv/ /mnt/srv/http /mnt/srv/http/public /mnt/srv/http/intern && mount -o rw,nosuid,nodev,relatime /dev/data/docs /mnt/srv/http/public && mount -o rw,nosuid,nodev,relatime /dev/data/note /mnt/srv/http/intern &

reflector -f 5 -c id --save /etc/pacman.d/mirrorlist

pacstrap /mnt/ linux-hardened linux-firmware mkinitcpio intel-ucode lvm2 base base-devel neovim git openssh polkit less firewalld tang clevis mkinitcpio-nfs-utils luksmeta apparmor libpwquality rsync reflector nftables tuned tuned-ppd irqbalance nginx&

genfstab -U /mnt/ > /mnt/etc/fstab &
 
cp /etc/systemd/network/* /mnt/etc/systemd/network/ &

echo 'tmpfs     /tmp        tmpfs   defaults,rw,nosuid,nodev,noexec,relatime,size=1G    0 0' >> /mnt/etc/fstab &

echo 'tmpfs     /dev/shm    tmpfs   defaults,rw,nosuid,nodev,noexec,relatime,size=1G    0 0' >> /mnt/etc/fstab &

cp -fr "$DURS/init-logs//cfg/*" /mnt/

cp -f "$DURS/init-logs/env" /mnt/init

arch-chroot /mnt /bin/bash /init/main



echo "
Do not forget to activate this command bellow after reboot

ln -sf ../run/systemd/resolve/stub-resolv.conf /etc/resolv.conf

systemctl restart systemd-networkd

systemctl restart systemd-resolved


you will automaticaly reboot at 20 s 
"

sleep 20

umount -R /mnt

reboot