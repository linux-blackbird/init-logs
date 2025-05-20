#!/bin/bash
APPS=$(pwd)/init-logs
source "$APPS/env"
source "$APPS/cfg/init/lib/storage.sh"
source "$APPS/cfg/init/lib/package.sh"


## PREPARE
umount -R /mnt > /dev/null &
prepinst=$!
wait $prepinst



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



## INSTALL PACKAGE PACKAGE
install_package_main_admiral_basics
prepare_configuration_admiral_basic


## CHROOT INSTALL PACKAGE
arch-chroot /mnt /bin/bash /init/main