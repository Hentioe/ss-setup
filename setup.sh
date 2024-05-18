#!/bin/sh

# Create new chain for IPv4
iptables -t nat -N SHADOWSOCKS
# Create new chain for IPv6
ip6tables -t nat -N SHADOWSOCKS
# Create new ipset for China's IPv4 addresses
ipset create chnroute hash:net maxelem 65536
# Create new ipset for China's IPv6 addresses
ipset create chnroute6 hash:net family inet6

# Add China routing table for IPv4
for ip in $(cat 'china-ipv4.txt'); do
    ipset add chnroute $ip
done

# Add China routing table for IPv6
for ip in $(cat 'china-ipv6.txt'); do
    ipset add chnroute6 $ip
done

# Add whitelist for IPv4
for ip in $(cat 'whitelist.txt'); do
    ipset add chnroute $ip
done

# Add whitelist for IPv6
for ip in $(cat 'whitelist6.txt'); do
    ipset add chnroute6 $ip
done

# Ignore your shadowsocks server's addresses
# It's very IMPORTANT, just be careful.

# Ignore LANs and any other addresses you'd like to bypass the proxy
# IPv4
iptables -t nat -A SHADOWSOCKS -d 0.0.0.0/8 -j RETURN
iptables -t nat -A SHADOWSOCKS -d 127.0.0.0/8 -j RETURN
iptables -t nat -A SHADOWSOCKS -d 192.168.0.0/16 -j RETURN
# IPv6
ip6tables -t nat -A SHADOWSOCKS -d ::1/128 -j RETURN
ip6tables -t nat -A SHADOWSOCKS -d fc00::/7 -j RETURN
ip6tables -t nat -A SHADOWSOCKS -d fe80::/10 -j RETURN
ip6tables -t nat -A SHADOWSOCKS -d fd00::/8 -j RETURN

# Directly connected to China IPv4 addresses
iptables -t nat -A SHADOWSOCKS -p tcp -m set --match-set chnroute dst -j RETURN

# Directly connected to China IPv6 addresses
ip6tables -t nat -A SHADOWSOCKS -p tcp -m set --match-set chnroute6 dst -j RETURN

# Redirect everything else to shadowsocks's local port
iptables -t nat -A SHADOWSOCKS -p tcp -j REDIRECT --to-ports 1080  # IPv4
ip6tables -t nat -A SHADOWSOCKS -p tcp -j REDIRECT --to-ports 1080 # IPv6

# Apply the rules for incoming traffic
iptables -t nat -A PREROUTING -p tcp -j SHADOWSOCKS  # IPv4
ip6tables -t nat -A PREROUTING -p tcp -j SHADOWSOCKS # IPv6

# Apply the rules for local output
iptables -t nat -A OUTPUT -p tcp -j SHADOWSOCKS  # IPv4
ip6tables -t nat -A OUTPUT -p tcp -j SHADOWSOCKS # IPv6
