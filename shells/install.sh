#!/bin/sh

# ===== function =================================================="
help() {
    echo "===== Lite Raspberry AP Installer ============================="
    echo "===== Usage ==================================================="
    echo "Argument"
    echo "  shells/install.sh <conf>"
    echo "    <conf>: configuration path."
    echo "ex. standalone"
    echo "  -> modify files in conf/standalone"
    echo "  $ pwd"
    echo "  /path/to/LiteRaspberryAP"
    echo "  $ sudo sh shells/install.sh conf/standalone"
    echo "==============================================================="
}

add_interfaces() {
    # $1: conf path
    if ! ls "$1" > /dev/null 2>&1; then
        return 1
    fi
    echo "===== add interfaces ====="
    \cp -f "$1"/* /etc/network/interfaces.d/
    chmod 644 /etc/network/interfaces.d/*
    chown root:root /etc/network/interfaces.d/*
    for DEV in "$1"/*
    do
        ip addr flush dev "$(basename "${DEV}")"
    done
    systemctl restart dhcpcd
    systemctl restart networking
}

install_dhcpcd() {
    # $1: conf path
    if ! ls "$1" > /dev/null 2>&1; then
        return 1
    fi
    echo "===== install dhcpcd ====="
    systemctl stop dhcpcd

    if ! ls /etc/dhcpcd.conf.org > /dev/null 2>&1; then
        \cp -f /etc/dhcpcd.conf /etc/dhcpcd.conf.org
    fi

    \cp -f "$1" /etc/dhcpcd.conf
    chmod 664 /etc/dhcpcd.conf
    chown root:netdev /etc/dhcpcd.conf

    systemctl enable dhcpcd
    systemctl start dhcpcd
}

install_dnsmasq() {
    if ! ls "$1" > /dev/null 2>&1; then
        return 1
    fi
    echo "===== install dnsmasq ====="
    apt-get install -y dnsmasq
    systemctl stop dnsmasq

    if ! ls /etc/dnsmasq.conf.org > /dev/null 2>&1; then
        \cp -f /etc/dnsmasq.conf /etc/dnsmasq.conf.org
    fi

    \cp -f "$1" /etc/dnsmasq.conf
    chmod 644 /etc/dnsmasq.conf
    chown root:root /etc/dnsmasq.conf

    systemctl enable dnsmasq
    systemctl start dnsmasq
}

install_hostapd() {
    # $1: conf path
    if ! ls "$1" > /dev/null 2>&1; then
        return 1
    fi
    echo "===== install hostapd ====="
    apt-get install -y hostapd
    systemctl stop hostapd

    if ! ls /etc/hostapd/hostapd.conf.org > /dev/null 2>&1; then
        \cp -f /etc/hostapd/hostapd.conf /etc/hostapd/hostapd.conf.org > /dev/null 2>&1
    fi

    \cp -f "$1" /etc/hostapd/hostapd.conf
    chmod 660 /etc/hostapd/hostapd.conf
    chown root:root /etc/hostapd/hostapd.conf

    sed -i '/#DAEMON_CONF=""/a DAEMON_CONF="/etc/hostapd/hostapd.conf"' /etc/default/hostapd
    if ! grep -e "ExecStartPre" /lib/systemd/system/hostapd.service > /dev/null 2>&1; then
        sed -i "/ExecStart=/a ExecStartPre=/bin/sleep 10" /lib/systemd/system/hostapd.service
    fi

    systemctl unmask hostapd
    systemctl enable hostapd
    systemctl start hostapd
}

install_bridge() {
    apt-get install -y bridge-utils

}

# ===== script =================================================="
if [ "$(whoami)" != "root" ]; then
    echo "===== please execute with root. ===="
    exit 1
fi

if [ "$#" != 1 ]; then
    echo "===== invalid argument. ===="
    help
    exit 1
fi

if ! ping -c 4 8.8.8.8 > /dev/null 2>&1; then
    echo "===== can not connect to internet. ====";
    exit 1
fi

systemctl stop hostapd
systemctl disable hostapd
systemctl stop dnsmasq
systemctl disable dnsmasq
echo "/etc/network/interfaces.d/ -> $(ls /etc/network/interfaces.d/)"
printf "Do you remove all in /etc/network/interfaces.d/? [Y/n]: "
read -r INIT_DONE
case "${INIT_DONE}" in
    [yY])
        rm -f /etc/network/interfaces.d/*
        systemctl restart networking
    ;;
esac

add_interfaces "$1"/interfaces
install_dhcpcd "$1"/dhcpcd.conf
install_dnsmasq "$1"/dnsmasq.conf
install_hostapd "$1"/hostapd.conf
install_bridge