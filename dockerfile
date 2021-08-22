FROM balenalib/raspberrypi3-debian

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
  && sudo apt-get install git \
  && git clone https://github.com/koenkooi/foo2zjs.git  \
  && cd foo2zjs \
  && sudo make \
  && sudo make install

COPY etc/cups/cupsd.conf /etc/cups/cupsd.conf
COPY entrypoint.sh /

EXPOSE 631
ENTRYPOINT /entrypoint.sh
