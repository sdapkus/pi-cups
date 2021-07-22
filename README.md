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


## First run
```bash
cd foo2zjs
./getweb 1020
sudo make install
cat /usr/share/foo2zjs/firmware/sihp1020.dl > /dev/usb/lp0
```
