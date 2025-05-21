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

    setup_storage_blackbird_protocol_fresh &&
    install_package_main_blackbird_basics &&
    prepare_configuration_blackbird_basic &&
    arch-chroot /mnt /bin/bash /init/main


elif [[ $MODE == "swipe" ]];then

    setup_storage_blackbird_protocol_swipe

elif [[ $MODE == "reset" ]];then

    setup_storage_blackbird_protocol_reset

else
    
    echo "error : undefined parameter, used "install", "swipe", or "reset" for parameter ";
fi



## INSTALL PACKAGE



## CHROOT INSTALL PACKAGE
