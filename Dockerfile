FROM python:3.7
LABEL maintainer="Ben Yarmis <ben@yarm.is>"

COPY systemctl.py /usr/bin/systemctl

RUN apt-get update -y;\
    apt-get upgrade -y;
RUN apt-get install -y git bc i2c-tools fonts-freefont-ttf whiptail make gcc python3-pil python3-smbus python3-dateutil libfuse-dev sudo

#systemd dbus-user-session 

# \/ Put this in a requirements \/
RUN pip3 install smbus Pillow python-dateutil RPi.GPIO
# /\ Put this in a requirements /\

RUN git clone --depth=1 https://github.com/PiSupply/PaPiRus.git
WORKDIR PaPiRus
RUN python3 setup.py install
WORKDIR /

RUN git clone https://github.com/repaper/gratis.git
WORKDIR gratis
RUN make rpi EPD_IO=epd_io.h PANEL_VERSION='V231_G2'
RUN make rpi-install EPD_IO=epd_io.h PANEL_VERSION='V231_G2'
RUN systemctl enable epd-fuse.service
WORKDIR /

RUN rm -rf gratis PaPiRus

COPY ./entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]

