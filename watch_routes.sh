#!/bin/bash

# Function to generate Nginx configuration from routes.trp
generate_config() {
    echo "Generating Nginx configuration..."

    # Remove existing configuration files
    echo "Removing existing configuration files..."
    rm -f /etc/nginx/conf.d/*.conf

    # Parse routes.trp and generate Nginx configuration
    echo "Parsing routes.trp and generating Nginx configuration..."
    while IFS=' => ' read -r domain target; do
        # Trim leading/trailing whitespaces
        domain=$(echo "$domain" | awk '{$1=$1;print}')
        target=$(echo "$target" | awk '{$1=$1;print}')

        # Generate Nginx configuration block for each domain
        echo "Generating configuration block for domain: $domain; target: $target"
        echo "
            server {
                listen 80;
                server_name $domain;

                location / {
                    if (\$http_host != '$domain') {
                            return 403;
                    }
                    proxy_pass $target;
                    proxy_set_header Host \$host;
                    proxy_set_header X-Real-IP \$remote_addr;
                    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
                    proxy_set_header X-Forwarded-Proto \$scheme;
                    proxy_pass_request_headers on;
                }
            }
        " > /etc/nginx/conf.d/$domain.conf

    done < <(awk -F' => ' '!/^ *#/ && NF>0 {print $1,$2}' /etc/nginx/routes.trp)

    echo "Lint..."
    cd /etc/nginx/ && sh config_checker.sh;

    # Reload Nginx to apply changes
    echo "Reloading Nginx to apply changes..."
    nginx -s reload

    echo "Print vhosts..."
    nginx -T | grep "server_name "

    service nginx restart
}

echo "Dynamic routing script started..."

# Generate initial configuration
generate_config

# Monitor routes.trp for changes and regenerate Nginx configuration
echo "Monitoring routes.trp for changes..."
while inotifywait -e modify /etc/nginx/routes.trp; do
    echo "routes.trp has been modified. Regenerating Nginx configuration..."
    generate_config
done
