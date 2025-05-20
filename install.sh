#!/bin/bash
APPS=$(pwd)/init-logs
source "$APPS/env"
source "$APPS/cfg/init/lib/storage.sh"



if [[ -d /mnt/boot ]];then
    umount -R /mnt
fi


if [[ $1 == "install" ]];then

    setup_storage_admiral_protocol_fresh

elif [[ $1 == "swipe" ]];then

    setup_storage_admiral_protocol_swipe

elif [[ $1 == "reset" ]];then

    setup_storage_admiral_protocol_reset

else
    
    echo "error : undefined parameter, used "install", "swipe", or "reset" for parameter ";
fi



