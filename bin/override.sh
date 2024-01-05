#!/bin/bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
SOURCE_DIR=$SCRIPT_DIR/..

cd /home/unms/app

# Get UCRM version from current docker-compose.yml
UCRM_VERSION=$(sed -nE 's|^\s*image:\s*ubnt/unms-crm:(.*)|\1|p' docker-compose.yml)

########################################################################################################################
# OVERRIDES
########################################################################################################################

#if [ ! -d /home/unms/app/overrides ]
if [ ! -d overrides ]
then
    ln -s $SOURCE_DIR/app/overrides overrides
fi

compose=$SOURCE_DIR/app/docker-compose.override.yml

sed -i.bak -E "s/(UCRM_VERSION|ubnt\/unms-crm)(: ?)[0-9]+\.[0-9]+\.[0-9]+(-xdebug)?$/\1\2$UCRM_VERSION\3/g" $compose

if ! diff "$compose" "$compose.bak" &> /dev/null; then
  echo "File 'docker-compose.override.yml' has been updated!"
fi

rm "$compose.bak"

# Always (re-)link
rm -f docker-compose.override.yml
ln -s $compose docker-compose.override.yml

########################################################################################################################
# xdebug_params
########################################################################################################################

params=./overrides/ucrm/xdebug_params

# Change the serverName in xdebug_params based on the current hostname
sed -i.bak -E "s/\"serverName=[a-z_-]+\"/\"serverName=$(hostname)\"/" $params

if ! diff "$params" "$params.bak" &> /dev/null; then
  echo "File 'xdebug_params' has been updated!"
fi

rm "$params.bak"

########################################################################################################################
# xdebug.log
########################################################################################################################
#xdebug_log=/home/unms/data/ucrm/log/ucrm/app/logs/xdebug.log

#touch $xdebug_log
#chmod 775 $xdebug_log
#chown vagrant:vagrant $xdebug_log

########################################################################################################################
# Build
########################################################################################################################

# Restart UCRM while forcing a (re-)build of our custom docker image.
docker-compose -p unms up -d --build ucrm

# FUTURE: Maybe see what this does and simulate?
docker exec unms-nginx sh -c /refresh-configuration.sh



# Always (re-)link
rm -f post_update.sh
ln -s $SOURCE_DIR/app/post_update.sh post_update.sh
chmod +x post_update.sh
/home/unms/app/post_update.sh
