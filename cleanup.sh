#!/bin/sh

# Remove OUTPUT chain rule that jumps to SHADOWSOCKS
iptables -t nat -D OUTPUT -p tcp -j SHADOWSOCKS  # IPv4
ip6tables -t nat -D OUTPUT -p tcp -j SHADOWSOCKS # IPv6

# Remove PREROUTING chain rule that jumps to SHADOWSOCKS
iptables -t nat -D PREROUTING -p tcp -j SHADOWSOCKS  # IPv4
ip6tables -t nat -D PREROUTING -p tcp -j SHADOWSOCKS # IPv6

# Flush SHADOWSOCKS chain in nat table
iptables -t nat -F SHADOWSOCKS  # IPv4
ip6tables -t nat -F SHADOWSOCKS # IPv6

# Delete SHADOWSOCKS chain from nat table
iptables -t nat -X SHADOWSOCKS  # IPv4
ip6tables -t nat -X SHADOWSOCKS # IPv6

# Destroy chnroute ipset
ipset destroy chnroute  # IPv4
ipset destroy chnroute6 # IPv6
