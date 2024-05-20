#!/bin/bash

# Update package list and install necessary packages
sudo apt update
sudo apt install -y lxde-core lxterminal xorg dbus-x11 x11-xserver-utils
sudo apt install -y x11vnc nginx git openssl
