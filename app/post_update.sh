#!/usr/bin/env bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

########################################################################################################################
# Run Plugin Hooks
########################################################################################################################

cd /home/unms/data/ucrm/ucrm/data/plugins

# Loop through plugins...
for plugin in *
do
    if [ -d "$plugin" ]
    then
        echo "Executing $plugin/hook_update.php"
        docker exec ucrm bash -c "cd /data/ucrm/data/plugins/$plugin && php hook_update.php"
    fi
done

cd
