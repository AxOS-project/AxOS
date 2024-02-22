#!/bin/sh
mount -t proc proc /proc
mount -t sysfs sys /sys
mount -t devtmpfs udev /dev

rm /etc/xdg/autorun/mount-proc.sh
