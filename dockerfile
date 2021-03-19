FROM resin/rpi-raspbian

RUN apt-get update && apt-get install -y \
  curl \
  sudo \
  locales \
  whois \
  cups \
  cups-filters \
  cups-pdf \
  cups-client \
  cups-bsd \
  printer-driver-all \
  lsb

RUN sed -i "s/^#\ \+\(en_US.UTF-8\)/\1/" /etc/locale.gen \
  && locale-gen en_US en_US.UTF-8

ENV LANG=en_US.UTF-8 \
  LC_ALL=en_US.UTF-8 \
  LANGUAGE=en_US:en

RUN useradd \
  --groups=sudo,lp,lpadmin \
  --create-home \
  --home-dir=/home/print \
  --shell=/bin/bash \
  --password=$(mkpasswd print) \
  print \
  && sed -i '/%sudo[[:space:]]/ s/ALL[[:space:]]*$/NOPASSWD:ALL/' /etc/sudoers \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && mkdir /var/lib/apt/lists/partial

RUN sudo apt-get update \
  && sudo apt-get install wget \
  && sudo apt-get install dc \
  && wget -O foo2zjs.tar.gz http://foo2zjs.rkkda.com/foo2zjs.tar.gz \
  && tar zxf foo2zjs.tar.gz \
  && cd foo2zjs \
  && make \
  && ./getweb 1020 \
  && sudo make install

COPY etc/cups/cupsd.conf /etc/cups/cupsd.conf
COPY entrypoint.sh /

EXPOSE 631
ENTRYPOINT /entrypoint.sh
