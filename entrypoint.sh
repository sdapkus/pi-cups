#!/bin/bash
cat /usr/share/foo2zjs/firmware/sihp1020.dl > /dev/usb/lp0

./usr/sbin/cupsd -f
