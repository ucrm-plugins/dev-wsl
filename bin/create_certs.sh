#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

if [ ! -f /usr/bin/mkcert.exe ]
then
    URL=https://dl.filippo.io/mkcert/latest?for=windows/amd64
    wget -q --show-progress "$URL" -O /usr/bin/mkcert.exe
    chmod +x /usr/bin/mkcert.exe
fi

mkcert.exe -install
mkcert.exe -cert-file uisp.crt -key-file uisp.key uisp uisp.dev localhost

mv uisp.crt /etc/ssl/certs
mv uisp.key /etc/ssl/certs
chown root:root /etc/ssl/certs/uisp.*
