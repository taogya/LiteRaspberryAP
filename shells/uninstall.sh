#!/bin/sh

trap 'echo "cancel uninstall."; exit 1' 2

# ===== function =================================================="
help() {
    echo "===== Raspberry Server Uninstaller ==========================="
    echo "===== Usage =================================================="
    echo "Argument"
    echo "  nothing"
    echo "ex."
    echo "  $ pwd"
    echo "  /path/to/RaspberryServer"
    echo "  $ sudo shells/uninstall.sh"
    echo "=============================================================="
}

# ===== script =================================================="
if [ "$(whoami)" != "root" ]; then
    echo "===== please execute with root. ===="
    exit 1
fi

echo "===== remove hostapd ====="
printf "Do you remove hostapd? [Y/n]: "
read -r INIT_DONE
case "${INIT_DONE}" in
    [yY])
        systemctl stop hostapd
        systemctl disable hostapd
        apt-get purge --auto-remove -y hostapd
    ;;
esac

echo "===== remove dnsmasq ====="
printf "Do you remove dnsmasq? [Y/n]: "
read -r INIT_DONE
case "${INIT_DONE}" in
    [yY])
        systemctl stop dnsmasq
        systemctl disable dnsmasq
        apt-get purge --auto-remove -y dnsmasq
    ;;
esac

echo "===== remove bridge-utils ====="
printf "Do you remove bridge-utils? [Y/n]: "
read -r INIT_DONE
case "${INIT_DONE}" in
    [yY])
        apt-get purge --auto-remove -y bridge-utils
    ;;
esac

echo "===== manual operation ====="
echo "operate by manual to modify or remove file below."
echo "  /etc/hostapd"
echo "  /etc/dnsmasq.conf"
echo "  /etc/dhcpcd.conf"
echo "  /etc/network/interfaces.d/*"
echo "  /etc/wpa_supplicant/wpa_supplicant.conf"
echo "  /etc/udev/rules.d/99-ap0.rules"
