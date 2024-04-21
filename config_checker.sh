#!/bin/bash

CONFIG_DIR="/etc/nginx/conf.d"
TMP_FILE="/tmp/nginx_config_list"

> $TMP_FILE

for file in $CONFIG_DIR/*.conf; do
    nginx -t -c "$file" >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "include $file;" >> $TMP_FILE
    else
        echo "Skipping $file due to errors"
    fi
done

nginx -t -c "$TMP_FILE"
if [ $? -eq 0 ]; then
    mv $TMP_FILE $CONFIG_DIR/nginx_include.conf
    echo "All configs passed. Including in Nginx configuration."
else
    echo "Some configs failed. Check error logs."
fi