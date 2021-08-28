# CUPS

Printing with AirPrint from macbook or iPhone to Epson (L355) and Dymo (4XL) printers connected to Raspberry PI3 with docker

## docker-compose

```bash
docker-compose run
```

## docker

### build

```bash
docker build --rm -f dockerfile -t pi-cups:latest .
```

### run

```bash
docker run -d -p 631:631 --privileged -v /var/run/dbus:/var/run/dbus -v /dev/bus/usb:/dev/bus/usb --name pi-cups pi-cups
```

## configure

open with your favourite web browser:

```bash
http://<YOUR_PI_IP_ADDRESS>:631
```

u: print

p: print


## First run ~ Not sure if needed
```bash
cd foo2zjs
sudo make install
sudo make
cat /usr/share/foo2zjs/firmware/sihp1020.dl > /dev/usb/lp0
```


## Hotplug hack

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
PRODUCT=90c/1000/1100  <--------------------------------------------------------- ENV{PRODUCT}
SEQNUM=2192
SUBSYSTEM=usb          <--------------------------------------------------------- " SUBSYSTEM=="type_of_device"
```

Edit file `/etc/udev/rules.d/test.rules`
Add:

```bash
ACTION=="add", SUBSYSTEM=="usb", ENV{PRODUCT}=="90c/1000/1100", RUN=="/bin/bash /root/pi-cups/hotplug.sh"
```

Create & edit file `/root/pi-cups/hotplug.sh`

```bash
#/bin/bash
sleep 5
cat /usr/share/foo2zjs/firmware/sihp1020.dl > /dev/usb/lp0
```

Run
```bash
chmod +x /root/pi-cups/hotplug.sh
udevadm control --reload
```


Done! On each printer connection driver should be auto-loaded.
