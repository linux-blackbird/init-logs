#!/bin/bash

## PREPARE


APPS=/init-logs
printf "\nMODE=$1" >> $APPS/env


## DECLARE EVN
source "$APPS/env"
source "$APPS/cfg/init/lib/storage.sh"
source "$APPS/cfg/init/lib/package.sh"
source "$APPS/cfg/init/lib/setconf.sh"





## STORAGE PREPARE
if [[ $MODE == "install" ]];then

    umount -R /mnt/boot
    umount -R /mnt/home 
    umount -R /mnt/var 
    umount -R /mnt/srv 
    umount -R /mnt

    setup_storage_blackbird_protocol_fresh

elif [[ $MODE == "swipe" ]];then

    setup_storage_blackbird_protocol_swipe

elif [[ $MODE == "reset" ]];then

    setup_storage_blackbird_protocol_reset

else
    
    echo "error : undefined parameter, used "install", "swipe", or "reset" for parameter ";
fi



INSTALL PACKAGE
install_package_main_blackbird_basics &&
prepare_configuration_blackbird_basic &&


## CHROOT INSTALL PACKAGE
arch-chroot /mnt /bin/bash /init/main