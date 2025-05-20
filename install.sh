#!/bin/bash
PATH=$(pwd)/init-logs
source "$PATH/env"
source "$PATH/cfg/init/lib/storage.sh"


if [[ $1 == "install" ]];then

    setup_storage_admiral_protocol_fresh

elif [[ $1 == "swipe" ]];then

    setup_storage_admiral_protocol_swipe

else

    setup_storage_admiral_protocol_reset
fi



