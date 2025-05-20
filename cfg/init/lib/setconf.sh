function prepare_configuration_blackbird_basic() {

    genfstab -U /mnt/ > /mnt/etc/fstab &
 
    echo 'tmpfs     /tmp        tmpfs   defaults,rw,nosuid,nodev,noexec,relatime,size=1G    0 0' >> /mnt/etc/fstab &
    echo 'tmpfs     /dev/shm    tmpfs   defaults,rw,nosuid,nodev,noexec,relatime,size=1G    0 0' >> /mnt/etc/fstab &

    cp /etc/systemd/network/* /mnt/etc/systemd/network/
    cp -fr "$APPS/cfg/*" /mnt/
    cp -f  "$APPS/env" /mnt/init
}


function install_configuration_blackbird_basic() {

    echo $HOSTNAMED > /etc/hostname

    ln -sf /usr/share/zoneinfo/Asia/Jakarta /etc/localtime 

    hwclock --systohc 

    timedatectl set-ntp true 

    printf "en_US.UTF-8 UTF-8\nen_US ISO-8859-1" >> /etc/locale.gen 

    locale-gen && locale > /etc/locale.conf 

    sed -i '1s/.*/'LANG=en_US.UTF-8'/' /etc/locale.conf 

    echo 'EDITOR="/usr/bin/nvim"' >> /etc/environment 
}


function register_user_masters_blackbird_basic() {
    mkdir /opt/rsyslog
    echo 'h3x0r ALL=(ALL:ALL) ALL' > /etc/sudoers.d/00_lektor
    useradd -d /opt/rsyslog h3x0r
    chown h3x0r:h3x0r /opt/rsyslog
    usermod -a -G wheel h3x0r
    passwd h3x0r
}


function register_user_siteman_blackbird_basic() {
    useradd -d /srv/http/ www
    setfacl -Rm u:www:rwx /srv/http/
    passwd www
}


function register_user_adminer_blackbird_basic() {
    useradd -m lektor
    passwd joyboy
}