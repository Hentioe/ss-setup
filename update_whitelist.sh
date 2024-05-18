#!/bin/sh

# Add whitelist IPv4 to ipset
for ip in $(cat 'whitelist.txt'); do
    if ! ipset test chnroute $ip >/dev/null 2>&1; then
        ipset add chnroute $ip
        echo "Add $ip to chnroute"
    fi
done

# Add whitelist IPv6 to ipset
for ip in $(cat 'whitelist6.txt'); do
    if ! ipset test chnroute6 $ip >/dev/null 2>&1; then
        ipset add chnroute6 $ip
        echo "Add $ip to chnroute6"
    fi
done
