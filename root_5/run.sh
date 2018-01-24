#!/bin/sh
# Turn debug on
set -x

if [ -z "$MYGID" ] || [ -z "$MYUID" ]; then
    echo "WARNING: You did not set MYGID/MYUID, skipping ownership change."
else
    echo "Setting UID/GID for www-data user"

    # Set UID/GID for www-data user to whatever the user wants
    usermod -u ${MYUID} www-data
    groupmod -g ${MYGID} www-data

    # We have to chown these files for apache to start
    # Doing this with find is more flexible but takes an eternity
    chown -hR $MYUID:$MYGID /run/lock/apache2
    chown -hR $MYUID:$MYGID /run/apache2
    chown -hR $MYUID:$MYGID /var/cache/apache2/mod_cache_disk
    chown -hR $MYUID:$MYGID /var/log/apache2

    echo "Permissions set successfully; starting Apache"
fi

# Start apache now
apache2-foreground
