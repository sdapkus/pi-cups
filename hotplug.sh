#!/bin/bash

# The HP LaserJet 1020 needs its firmware uploaded after every power-up.
# Wait for the usblp device node instead of assuming it is there after 2s.
for i in $(seq 1 30); do
  [ -e /dev/usb/lp0 ] && break
  sleep 1
done

if [ ! -e /dev/usb/lp0 ]; then
  echo "hotplug: /dev/usb/lp0 not found, skipping firmware upload (is usblp loaded on the host?)" >&2
  exit 0
fi

cat /usr/share/foo2zjs/firmware/sihp1020.dl > /dev/usb/lp0
