#!/bin/bash


function blackbird_cis_level_2_policy_crontab() {

    if [[ ! -e /etc/crontab ]];then
        touch /etc/crontab
    fi
    chown root:root /etc/crontab && chmod og-rwx /etc/crontab 


    if [[ ! -d /etc/cron.hourly ]];then
        mkdir /etc/cron.hourly
    fi
    chown root:root /etc/cron.hourly/ && chmod og-rwx /etc/cron.hourly/ 


    if [[ ! -d /etc/cron.daily ]];then
        mkdir /etc/cron.daily
    fi
    chown root:root /etc/cron.daily/ && chmod og-rwx /etc/cron.daily/


    if [[ ! -d /etc/cron.weekly ]];then
        mkdir /etc/cron.weekly
    fi
    chown root:root /etc/cron.weekly/ && chmod og-rwx /etc/cron.weekly/
    

    if [[ ! -d /etc/cron.monthly ]];then
        mkdir /etc/cron.monthly
    fi
    chown root:root /etc/cron.monthly/ && chmod og-rwx /etc/cron.monthly/


    if [[ ! -d /etc/cron.d ]];then
        mkdir /etc/cron.d
    fi
    chown root:root /etc/cron.d/ && chmod og-rwx /etc/cron.d
}


function blackbird_cis_level_2_policy_filesys() {

    if [[ ! -e /etc/modprobe.d/10-blackbird-blacklist-fs.conf ]];then
        touch /etc/modprobe.d/10-blackbird-blacklist-fs.conf
    fi


    echo '## disable cramfs module' >> /etc/modprobe.d/10-blackbird-blacklist-fs.conf
    echo 'install cramfs /bin/false' > /etc/modprobe.d/10-blackbird-blacklist-fs.conf
    echo 'blacklist cramfs' >> /etc/modprobe.d/10-blackbird-blacklist-fs.conf


    echo '## disable hfs module' >> /etc/modprobe.d/10-blackbird-blacklist-fs.conf
    echo 'install hfs /bin/false' >> /etc/modprobe.d/10-blackbird-blacklist-fs.conf
    echo 'blacklist hfs' >> /etc/modprobe.d/10-blackbird-blacklist-fs.conf


    echo '## disable hfsplus module' >> /etc/modprobe.d/10-blackbird-blacklist-fs.conf
    echo 'install hfsplus /bin/false' >> /etc/modprobe.d/10-blackbird-blacklist-fs.conf
    echo 'blacklist hfsplus' >> /etc/modprobe.d/10-blackbird-blacklist-fs.conf


    echo '## disable jffs2 module' >> /etc/modprobe.d/10-blackbird-blacklist-fs.conf
    echo 'install jffs2 /bin/false' >> /etc/modprobe.d/10-blackbird-blacklist-fs.conf
    echo 'blacklist jffs2' >> /etc/modprobe.d/10-blackbird-blacklist-fs.conf


    echo '## disable squashfs module' >> /etc/modprobe.d/10-blackbird-blacklist-fs.conf
    echo 'install squashfs /bin/false' >> /etc/modprobe.d/10-blackbird-blacklist-fs.conf
    echo 'blacklist squashfs' >> /etc/modprobe.d/10-blackbird-blacklist-fs.conf


    echo '## disable udf module' >> /etc/modprobe.d/10-blackbird-blacklist-fs.conf
    echo 'install udf /bin/false' >> /etc/modprobe.d/10-blackbird-blacklist-fs.conf
    echo 'blacklist udf' >> /etc/modprobe.d/10-blackbird-blacklist-fs.conf


    echo '## disable usb-storage module' >> /etc/modprobe.d/10-blackbird-blacklist-fs.conf
    echo '## install usb-storage /bin/false' >> /etc/modprobe.d/10-blackbird-blacklist-fs.conf
    echo '## blacklist usb-storage' >> /etc/modprobe.d/10-blackbird-blacklist-fs.conf


    echo '## disable 9p module' >> /etc/modprobe.d/10-blackbird-blacklist-fs.conf
    echo 'install 9p /bin/false' >> /etc/modprobe.d/10-blackbird-blacklist-fs.conf
    echo 'blacklist 9p' >> /etc/modprobe.d/10-blackbird-blacklist-fs.conf


    echo '## disable affs module' >> /etc/modprobe.d/10-blackbird-blacklist-fs.conf
    echo 'install affs /bin/false' >> /etc/modprobe.d/10-blackbird-blacklist-fs.conf
    echo 'blacklist affs' >> /etc/modprobe.d/10-blackbird-blacklist-fs.conf


    echo '## disable afs module' >> /etc/modprobe.d/10-blackbird-blacklist-fs.conf
    echo 'install afs /bin/false' >> /etc/modprobe.d/10-blackbird-blacklist-fs.conf
    echo 'blacklist afs' >> /etc/modprobe.d/10-blackbird-blacklist-fs.conf


    echo '## disable ceph module' >> /etc/modprobe.d/10-blackbird-blacklist-fs.conf
    echo 'install ceph /bin/false' >> /etc/modprobe.d/10-blackbird-blacklist-fs.conf
    echo 'blacklist ceph' >> /etc/modprobe.d/10-blackbird-blacklist-fs.conf


    echo '## disable fuse module' >> /etc/modprobe.d/10-blackbird-blacklist-fs.conf
    echo 'install fuse /bin/false' >> /etc/modprobe.d/10-blackbird-blacklist-fs.conf
    echo 'blacklist fuse' >> /etc/modprobe.d/10-blackbird-blacklist-fs.conf
}


function blackbird_cis_level_2_policy_enetsys() {

    if [[ ! -e /etc/modprobe.d/10-blackbird-blacklist-net.conf ]];then
        touch /etc/modprobe.d/10-blackbird-blacklist-net.conf
    fi


    echo '## disable dccp module' >> /etc/modprobe.d/10-blackbird-blacklist-net.conf
    echo 'install dccp /bin/false' > /etc/modprobe.d/10-blackbird-blacklist-net.conf
    echo 'blacklist dccp' >> /etc/modprobe.d/10-blackbird-blacklist-net.conf


    echo '## disable tipc module' >> /etc/modprobe.d/10-blackbird-blacklist-net.conf
    echo 'install tipc /bin/false' >> /etc/modprobe.d/10-blackbird-blacklist-net.conf
    echo 'blacklist tipc' >> /etc/modprobe.d/10-blackbird-blacklist-net.conf


    echo '## disable sctp module' >> /etc/modprobe.d/10-blackbird-blacklist-net.conf
    echo 'install sctp /bin/false' >> /etc/modprobe.d/10-blackbird-blacklist-net.conf
    echo 'blacklist sctp' >> /etc/modprobe.d/10-blackbird-blacklist-net.conf
}


function blackbird_cis_level_2_policy_install() {
    blackbird_cis_level_2_policy_crontab
    blackbird_cis_level_2_policy_filesys
    blackbird_cis_level_2_policy_install
}