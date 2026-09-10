# CUPS

Printing with AirPrint from macbook or iPhone to HP LaserJet 1020 printer connected to Raspberry PI4 with docker

## docker-compose

```bash
docker compose run
```

## docker

### build

```bash
docker build --rm -f dockerfile -t pi-cups:latest .
```

## configure

open with your favourite web browser:

```bash
http://<YOUR_PI_IP_ADDRESS>:631
```

u: print
p: print


## Hotplug hack

### On host machine:

Create `reload.sh` with content:
```bash
#!/bin/bash

docker compose -f <path to>/docker-compose.yaml  stop
docker compose -f <path to>/docker-compose.yaml up -d
```

Run
```bash
sudo chmod +x reload.sh
```

Run
```bash
udevadm monitor --kernel --property --subsystem-match=usb
```

Connect your printer, you should see something like this:
```bash
monitor will print the received events for:
KERNEL - the kernel uevent
KERNEL[6147.486744] add /devices/pci0000:00/0000:00:0c.0/usb1/1-2 (usb)
ACTION=add             <--------------------------------------------------------- ACTION of the device
BUSNUM=001
DEVNAME=/dev/bus/usb/001/010
DEVNUM=010
DEVPATH=/devices/pci0000:00/0000:00:0c.0/usb1/1-2
DEVTYPE=usb_device      
MAJOR=189
MINOR=9
PRODUCT=90c/1000/1100  <---------------------------------------------------------
SEQNUM=2192
SUBSYSTEM=usb          <---------------------------------------------------------
```

Edit file `/etc/udev/rules.d/test.rules`
Add:
```bash
ACTION=="add", SUBSYSTEM=="<<copy_subsystem>>", ENV{PRODUCT}=="<<copy_product>>", RUN+="/bin/bash <path to>/reload.sh"
```

Reload udev
```bash
udevadm control --reload
```

If printing does not work from the iPhone
```bash
lpadmin -p <printer-name> -o pdftops-renderer=gs
```

use `lpstat -p` to find printer name
