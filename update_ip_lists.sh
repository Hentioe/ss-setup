#!/bin/sh

# Download the file
curl http://ftp.apnic.net/apnic/stats/apnic/delegated-apnic-latest -o "delegated-apnic-latest.txt"

# Generate china-ipv4.txt from the local file
awk -F '|' '/CN/&&/ipv4/ {print $4 "/" 32-log($5)/log(2)}' "$local_file" >china-ipv4.txt

# Generate china-ipv6.txt from the local file
awk -F '|' '/CN/&&/ipv6/ {print $4 "/" $5}' "$local_file" >china-ipv6.txt

# Clean up
rm "$local_file"
