# LiteRaspberryAP
This set up Wi-Fi Access Point with Router or Bridge or Standalone on Raspberry Pi.

# Installation
## Clone Repository
```sh
$ sudo apt-get update
$ sudo apt-get upgrade
$ sudo apt-get dist-upgrade
$ 
$ sudo apt-get install git
$ 
$ mkdir -p ~/work && cd ~/work
$ git clone https://github.com/taogya/LiteRaspberryAP.git
$ cd LiteRaspberryAP
$ chmod -R +x shells/
```

## Select Mode & Modify conf, install
i/f below is for example eth0, wlan0, usb0, etc..
### Bridge
```
                                     target
                                     v      wlan0
+----------+   i/f +--------+ br0    +----+ <---> dev_1
| internet | <---> | Bridge | <----> | AP | <---> :
+----------+       +--------+        +----+ <---> dev_n
```
modify conf below.
  - [dhcpcd.conf](conf/bridge/dhcpcd.conf)  
    be copied to `/etc/dhcpcd.conf`
  - [hostapd.conf](conf/bridge/hostapd.conf)  
    be copied to `/etc/hostapd/hostapd.conf`
  - [wpa_supplicant.conf](conf/bridge/wpa_supplicant.conf)  
    be copied to `/etc/wpa_supplicant/wpa_supplicant.conf`

modify interfaces below. (be copied to `/etc/network/interfaces.d/*`)
  - [ap0](conf/bridge/interfaces/ap0)
  - [wlan0](conf/bridge/interfaces/wlan0)
  - [br0](conf/bridge/interfaces/br0)

install
```sh
sudo sh shells/install.sh conf/bridge
```

### Standalone
```
                   target
                   v      wlan0
+----------+   i/f +----+ <---> dev_1
| internet | <-x-> | AP | <---> :
+----------+       +----+ <---> dev_n
```
modify conf below.
  - [dhcpcd.conf](conf/standalone/dhcpcd.conf)  
    be copied to `/etc/dhcpcd.conf`
  - [hostapd.conf](conf/standalone/hostapd.conf)  
    be copied to `/etc/hostapd/hostapd.conf`
  - [dnsmasq.conf](conf/standalone/dnsmasq.conf)  
    be copied to `/etc/dnsmasq.conf`

modify interfaces below. (be copied to `/etc/network/interfaces.d/*`)
  - [ap0](conf/standalone/interfaces/ap0)
  - [wlan0](conf/standalone/interfaces/wlan0)

install
```sh
sudo sh shells/install.sh conf/standalone
```

# Uninstallation
```sh
sudo sh shells/uninstall.sh
```
