# Write the database connection to the config so the installer prefills it
if ! [ -e app/config/local.php ]; then
        php /make-local-config.php

        # Make sure our web user owns the config file if it exists
        chown www-data:www-data app/config/local.php
        mkdir -p /var/www/html/app/logs
        chown www-data:www-data /var/www/html/app/logs
fi