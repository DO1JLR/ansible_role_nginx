#!/bin/bash
set -euf -o pipefail

IFS=$'\n'

EVENT_NAME="$1"
[ "$EVENT_NAME" = "live-updated" ] || exit 42

while read -r host; do
    if [[ -e "/etc/nginx/sites-available/${host}_tls" ]]; then
        echo "Enabling tls site for ${host}"
        ln -s -f "/etc/nginx/sites-available/${host}_tls" "/etc/nginx/sites-enabled/${host}_tls"
    fi
done

exit 0
