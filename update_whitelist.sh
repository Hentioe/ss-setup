#!/bin/sh

# Add whitelist IPv4 to ipset
for ip in $(cat 'whitelist.txt'); do
    if ! ipset test chnroute $ip; then
        ipset add chnroute $ip
    fi
done

# Add whitelist IPv6 to ipset
for ip in $(cat 'whitelist6.txt'); do
    if ! ipset test chnroute6 $ip; then
        ipset add chnroute6 $ip
    fi
done
