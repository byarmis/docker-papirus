FROM python:3.7
LABEL maintainer="Ben Yarmis <ben@yarm.is>"

COPY systemctl.py /usr/bin/systemctl

RUN apt-get update -y;\
    apt-get install -y \
        bc \
        fonts-freefont-ttf \
        gcc \
        git \
        i2c-tools \
        libfuse-dev \
        make \
        python3-dateutil \
        python3-pil \
        python3-smbus \
        sudo \
        whiptail \
    ; \
    rm -rf /var/lib/apt/lists/*

# \/ Put this in a requirements \/
RUN pip3 install smbus Pillow python-dateutil RPi.GPIO
# /\ Put this in a requirements /\

RUN git clone --depth=1 https://github.com/PiSupply/PaPiRus.git
WORKDIR PaPiRus
RUN python3 setup.py install;\
    cd / ;\
    rm -rf PaPiRus

RUN git clone --depth=1 https://github.com/repaper/gratis.git
WORKDIR gratis
RUN make rpi EPD_IO=epd_io.h PANEL_VERSION='V231_G2';\
    make rpi-install EPD_IO=epd_io.h PANEL_VERSION='V231_G2';\
    systemctl enable epd-fuse.service;\
    cd / ;\
    rm -rf gratis

COPY ./entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]

