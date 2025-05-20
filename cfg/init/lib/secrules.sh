

function secrules_admiral_config_files() {
    

    chown root:root /etc/cron.d/ && chmod og-rwx /etc/cron.d 


    chown root:root /etc/crontab && chmod og-rwx /etc/crontab

    
    chown root:root /etc/cron.hourly/ && chmod og-rwx /etc/cron.hourly/

    
    chown root:root /etc/cron.daily/ && chmod og-rwx /etc/cron.daily/

    
    chown root:root /etc/cron.weekly/ && chmod og-rwx /etc/cron.weekly/

    
    chown root:root /etc/cron.monthly/ && chmod og-rwx /etc/cron.monthly/

} 


function secrules_admiral_storag_drive() {


    modprobe -r hfs 2> /dev/null && rmmod hfs 2> /dev/null 

    
    modprobe -r hfsplus 2> /dev/null && rmmod hfsplus 2> /dev/null

    
    modprobe -r jffs2 2> /dev/null && rmmod jffs2 2> /dev/null

    
    modprobe -r squashfs 2> /dev/null && rmmod squashfs 2> /dev/null

    
    modprobe -r udf 2> /dev/null && rmmod udf 2> /dev/null


    ## disable usb-storage file system module from kernel
    modprobe -r usb-storage 2>/dev/null && rmmod usb-storage 2>/dev/null
} 


function secrules_admiral_networ_proto() {


    modprobe -r 9p 2> /dev/null && rmmod 9p 2> /dev/null


    modprobe -r affs 2> /dev/null && rmmod affs 2> /dev/null


    modprobe -r afs 2> /dev/null && rmmod afs 2> /dev/null


    modprobe -r fuse 2> /dev/null && rmmod fuse 2> /dev/null


    systemctl mask nfs-server.service


    modprobe -r dccp 2> /dev/null && rmmod dccp 2>/dev/null


    modprobe -r rds 2> /dev/null && rmmod rds 2> /dev/null


    modprobe -r sctp 2> /dev/null && rmmod sctp 2> /dev/null
}

