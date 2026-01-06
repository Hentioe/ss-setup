#!/bin/sh

# 1. Create table and chains
nft add table inet ss_nat
nft flush table inet ss_nat

nft add chain inet ss_nat SHADOWSOCKS
nft add chain inet ss_nat prerouting { type nat hook prerouting priority dstnat \; policy accept \; }
nft add chain inet ss_nat output { type nat hook output priority filter \; policy accept \; }

# 2. Create sets
nft add set inet ss_nat chnroute { type ipv4_addr \; flags interval \; }
nft add set inet ss_nat chnroute6 { type ipv6_addr \; flags interval \; }

# Helper function to batch load IP lists into nftables sets
import_to_set() {
    set_name=$1
    file_list=$2

    # Print log message for progress
    echo "Loading $set_name from $file_list..."

    # Construct and pipe the batch command to nft
    {
        printf "add element inet ss_nat %s {\n" "$set_name"
        cat $file_list | sed 's/$/,/'
        printf "}\n"
    } | nft -f -

    # Print completion log
    echo "Finished loading $set_name."
}

# 3. Add China routing table and whitelist for IPv4
import_to_set "chnroute" "dist/china-ipv4.txt whitelist/4.txt"

# 4. Add China routing table and whitelist for IPv6
import_to_set "chnroute6" "dist/china-ipv6.txt whitelist/6.txt"

# 5. Bypass LANs and reserved addresses (Optimized to single lines)
nft add rule inet ss_nat SHADOWSOCKS ip daddr { 0.0.0.0/8, 10.0.0.0/8, 127.0.0.0/8, 169.254.0.0/16, 172.16.0.0/12, 192.168.0.0/16, 224.0.0.0/4, 240.0.0.0/4 } return
nft add rule inet ss_nat SHADOWSOCKS ip6 daddr { ::1/128, fc00::/7, fe80::/10, fd00::/8 } return

# 6. Bypass China IP sets
nft add rule inet ss_nat SHADOWSOCKS ip daddr @chnroute return
nft add rule inet ss_nat SHADOWSOCKS ip6 daddr @chnroute6 return

# 7. Redirect everything else to local port 1080
nft add rule inet ss_nat SHADOWSOCKS meta l4proto tcp redirect to :1080

# 8. Apply rules to hooks
nft add rule inet ss_nat prerouting meta l4proto tcp jump SHADOWSOCKS
nft add rule inet ss_nat output meta l4proto tcp jump SHADOWSOCKS
