#!/usr/bin/env bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

set -e

SOURCE_DIR=$SCRIPT_DIR/..

# Always (re-)link
rm -f post_update.sh
ln -s $SOURCE_DIR/app/post_update.sh post_update.sh
chmod +x post_update.sh
#/home/unms/app/post_update.sh

[[ $(command -v inotify-tools) ]] || sudo apt-get install -y inotify-tools
[[ $(command -v incron) ]] || sudo apt-get install -y incron

APP_DIR=/home/unms/app

! sudo grep -q $USER /etc/incron.allow && echo "$USER" | sudo tee -a /etc/incron.allow > /dev/null

incrontab --list > tmpincron 2>/dev/null
echo "$APP_DIR/unms.conf IN_MODIFY $APP_DIR/post_update.sh" > tmpincron
incrontab tmpincron > /dev/null 2>&1
rm -f tmpincron

