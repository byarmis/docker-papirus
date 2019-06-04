#!/bin/bash

set -e

export XDG_RUNTIME_DIR=/run/user/`id -u`
if [ -f /etc/default/epd-fuse ]; then
    source /etc/default/epd-fuse
fi

systemctl enable epd-fuse.service
systemctl start epd-fuse

papirus-set 2.0

exec "$@"
