#!/bin/bash

CONFIG_DIR="/etc/nginx/conf.d"
TMP_FILE="/tmp/nginx_config_list"
NGINX_MAIN_CONF="/etc/nginx/nginx.conf"

> $TMP_FILE
valid_configs=false

for file in $CONFIG_DIR/*.conf; do
    echo "Checking '$file'..."
    nginx -t -c "$file"
    echo "Result code '$?'..."

    if [ $? -eq 0 ]; then
        echo "include $file;" >> $TMP_FILE
        valid_configs=true
    else
        echo "Skipping $file due to errors"
    fi
done

if $valid_configs ; then
    echo "Updating the main Nginx configuration file"
    cat "$TMP_FILE" >> "$NGINX_MAIN_CONF"

    nginx -t
    if [ $? -eq 0 ]; then
        echo "All configs passed. Nginx configuration updated successfully."
    else
        echo "Error: Some configs failed. Check error logs."
    fi
else
    echo "Error: No valid configs found. Check error logs."
fi

rm "$TMP_FILE"
