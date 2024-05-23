#!/bin/bash

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Function to create routes.trp file if it doesn't exist
create_routes_file() {
    local routes_file="$script_dir/routes.trp"

    # Check if routes.trp file exists
    if [ ! -f "$routes_file" ]; then
        touch "$routes_file"
        echo "routes.trp file created."
    fi
}

# Function to create a new host entry in the router.trp file
create_host() {
    create_routes_file

    local domain=$1
    local target=$2

    # Check if both arguments are provided
    if [ -z "$domain" ] || [ -z "$target" ]; then
        echo "Usage: $0 create <domain> <target>"
        exit 1
    fi

    # Add the host entry to the router.trp file
    echo "$domain => $target" >> "$script_dir/routes.trp"
    echo "OK"
}

# Function to delete a host entry from the router.trp file
delete_host() {
    create_routes_file

    local domain=$1
    local target=$2

    # Check if both arguments are provided
    if [ -z "$domain" ] || [ -z "$target" ]; then
        echo "Usage: $0 delete <domain> <target>"
        exit 1
    fi

    # Create a temporary file
    local tmp_file=$(mktemp)

    # Remove the host entry from the router.trp file
    sed "/^$domain => $target$/d" "$script_dir/routes.trp" > "$tmp_file"

    # Move the contents of the temporary file back to routes.trp
    mv "$tmp_file" "$script_dir/routes.trp"

    echo "OK"
}

# Function to get all hosts in JSON format
get_all_hosts() {
    create_routes_file

    local first=true
    printf "["

    while IFS='=>' read -r domain target; do
        domain=$(echo "$domain" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
        target=$(echo "$target" | sed 's/^>//;s/^[[:space:]]*//;s/[[:space:]]*$//')
        if $first; then
            # shellcheck disable=SC2059
            printf "{\"domain\": \"$domain\", \"target\": \"$target\"}"
            first=false
        else
            # shellcheck disable=SC2059
            printf ",{\"domain\": \"$domain\", \"target\": \"$target\"}"
        fi
    done < "$script_dir/routes.trp"

    echo "]"
}

# Main script block
case "$1" in
    create)
        create_host "$2" "$3"
        ;;
    delete)
        delete_host "$2" "$3"
        ;;
    all)
        get_all_hosts
        ;;
    *)
        echo "Usage: $0 {create|delete|all}"
        exit 1
        ;;
esac

exit 0
