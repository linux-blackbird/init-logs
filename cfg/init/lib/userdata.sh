



function register_user_master() {

    mkdir /opt/share/firefox

    echo 'h3x0r ALL=(ALL:ALL) ALL' > /etc/sudoers.d/00_lektor

    useradd -d /usr/share/firefox h3x0r

    chown h3x0r:h3x0r /usr/share/firefox

    usermod -a -G wheel h3x0r

    passwd h3x0r

    usermod -a -G libvirt h3x0r
}


function register_user_vmhost() {

    useradd -d /opt/var/lib/livirt/images joyboy

    setfacl -Rm u:joyboy:rw /var/lib/libvirt/images

    passwd joyboy

    usermod -a -G libvirt joyboy
}



function register_user_normal() {

    useradd -m lektor
    passwd lektor

    usermod -a -G libvirt lektor
}



