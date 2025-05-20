#!/bin/bash

## PREPARE
umount -R /mnt > /dev/null
APPS=$(pwd)/init-logs
printf "\nMODE=$1" >> $APPS/env


## DECLARE EVN
source "$APPS/env"
source "$APPS/cfg/init/lib/storage.sh"
source "$APPS/cfg/init/lib/package.sh"
source "$APPS/cfg/init/lib/setconf.sh"


## STORAGE PREPARE
if [[ $1 == "install" ]];then

    setup_storage_admiral_protocol_fresh

elif [[ $1 == "swipe" ]];then

    setup_storage_admiral_protocol_swipe

elif [[ $1 == "reset" ]];then

    setup_storage_admiral_protocol_reset

else
    
    echo "error : undefined parameter, used "install", "swipe", or "reset" for parameter ";
fi



## INSTALL PACKAGE
install_package_main_blackbird_basics &&

genfstab -U /mnt/ > /mnt/etc/fstab &

echo 'tmpfs     /tmp        tmpfs   defaults,rw,nosuid,nodev,noexec,relatime,size=1G    0 0' >> /mnt/etc/fstab &
echo 'tmpfs     /dev/shm    tmpfs   defaults,rw,nosuid,nodev,noexec,relatime,size=1G    0 0' >> /mnt/etc/fstab &

cp /etc/systemd/network/* /mnt/etc/systemd/network/
cp -fr /init-logs/cfg/* /mnt/
cp -f  /init-logs/env /mnt/init/env/data



## CHROOT INSTALL PACKAGE
arch-chroot /mnt /bin/bash /init/main