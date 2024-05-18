#!/bin/sh

# Define the URL and local file path
url="http://ftp.apnic.net/apnic/stats/apnic/delegated-apnic-latest"
local_file="delegated-apnic-latest.txt"

# Download the file
curl -s "$url" -o "$local_file"

# Generate china-ipv4.txt from the local file
awk -F '|' '/CN/&&/ipv4/ {print $4 "/" 32-log($5)/log(2)}' "$local_file" >china-ipv4.txt

# Generate china-ipv6.txt from the local file
awk -F '|' '/CN/&&/ipv6/ {print $4 "/" $5}' "$local_file" >china-ipv6.txt

# Clean up
rm "$local_file"
