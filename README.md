# LiteRaspberryAP
This set up Wi-Fi Access Point with Router or Bridge or Standalone on Raspberry Pi.

# Installation
## Clone Repository
```sh
$ sudo apt-get update
$ sudo apt-get upgrade
$ sudo apt-get dist-upgrade
$ 
$ mkdir -p ~/work && cd ~/work
$ git clone https://github.com/taogya/LiteRaspberryAP.git
$ cd LiteRaspberryAP
$ chmod -R +x shells/
```

## Select Mode & Modify conf
i/f below is for example eth0, wlan0, usb0, etc..
### Router
```
                   target
                   v      ap0
+----------+   i/f +----+ <---> dev_1
| internet | <---> | AP | <---> :
+----------+       +----+ <---> dev_n
                   ip forwarding
```
work in progress
### Bridge
```
                                     target
                                     v      ap0
+----------+   i/f +--------+ br0    +----+ <---> dev_1
| internet | <---> | Bridge | <----> | AP | <---> :
+----------+       +--------+        +----+ <---> dev_n
```
work in progress
### Standalone
```
                   target
                   v      ap0
+----------+   i/f +----+ <---> dev_1
| internet | <-x-> | AP | <---> :
+----------+       +----+ <---> dev_n
```
work in progress

## Install
```sh
sudo sh shells/install.sh
```

# Uninstallation
```sh
sudo sh shells/uninstall.sh
```
