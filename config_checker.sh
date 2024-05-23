#!/bin/bash

CONFIG_DIR="/etc/nginx/conf.d"
TMP_FILE="/tmp/nginx_config_list"
CHILD_CONFIG_FILE="/etc/nginx/child_configs.conf"

> $TMP_FILE
valid_configs=false

for file in $CONFIG_DIR/*.conf; do
    echo "Checking '$file'..."
    nginx -t -c "$file"
    echo "Result code '$?'..."

    if [ $? -eq 0 ]; then
        echo "include '$file';" >> "$TMP_FILE"
        valid_configs=true
    else
        echo "Skipping $file due to errors"
    fi
done

if $valid_configs ; then
    echo "Updating the child configs file"
    mv "$TMP_FILE" "$CHILD_CONFIG_FILE"

    nginx -t
    if [ $? -eq 0 ]; then
        echo "All configs passed. Child configs file updated successfully."
    else
        echo "Error: Some configs failed. Check error logs."
    fi
else
    echo "Error: No valid configs found. Check error logs."
fi
