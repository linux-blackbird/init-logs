



function prepare_configuration_admiral_basic() {

    genfstab -U /mnt/ > /mnt/etc/fstab &
 
    echo 'tmpfs     /tmp        tmpfs   defaults,rw,nosuid,nodev,noexec,relatime,size=1G    0 0' >> /mnt/etc/fstab &
    echo 'tmpfs     /dev/shm    tmpfs   defaults,rw,nosuid,nodev,noexec,relatime,size=1G    0 0' >> /mnt/etc/fstab &

    cp /etc/systemd/network/* /mnt/etc/systemd/network/
    cp -fr "$APPS/cfg/*" /mnt/
    cp -f  "$APPS/env" /mnt/init
}


function install_configuration_admiral_basic() {

    echo $HOSTNAMED > /etc/hostname

    ln -sf /usr/share/zoneinfo/Asia/Jakarta /etc/localtime 

    hwclock --systohc 

    timedatectl set-ntp true 

    printf "en_US.UTF-8 UTF-8\nen_US ISO-8859-1" >> /etc/locale.gen 

    locale-gen && locale > /etc/locale.conf 

    sed -i '1s/.*/'LANG=en_US.UTF-8'/' /etc/locale.conf 

    echo 'EDITOR="/usr/bin/nvim"' >> /etc/environment 
}



function register_user_master_admiral_basic() {

    mkdir /opt/share/firefox

    echo 'h3x0r ALL=(ALL:ALL) ALL' > /etc/sudoers.d/00_lektor

    useradd -d /usr/share/firefox h3x0r

    chown h3x0r:h3x0r /usr/share/firefox

    usermod -a -G wheel h3x0r

    passwd h3x0r

    usermod -a -G libvirt h3x0r
}


function register_user_vmhos_admiral_basic() {

    useradd -d /opt/var/lib/livirt/images joyboy

    setfacl -Rm u:joyboy:rw /var/lib/libvirt/images

    passwd joyboy

    usermod -a -G libvirt joyboy
}



function register_user_normal_admiral_basic() {

    useradd -m lektor
    passwd lektor

    usermod -a -G libvirt lektor
}