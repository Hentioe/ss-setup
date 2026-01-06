#!/bin/sh -e

local_file=".delegated-apnic-latest.txt"

# Download the delegated-apnic-latest file
curl http://ftp.apnic.net/apnic/stats/apnic/delegated-apnic-latest -o "$local_file"

# If dist directory does not exist, create it
[ ! -d dist ] && mkdir dist

# Generate china-ipv4.txt from the local file
awk -F '|' '/CN/&&/ipv4/ {print $4 "/" 32-log($5)/log(2)}' "$local_file" >dist/china-ipv4.txt

echo -e "\nchina-ipv4.txt has been generated"

# Generate china-ipv6.txt from the local file
awk -F '|' '/CN/&&/ipv6/ {print $4 "/" $5}' "$local_file" >dist/china-ipv6.txt

echo "china-ipv6.txt has been generated"

cat dist/china-ipv4.txt dist/china-ipv6.txt >dist/china-ip-full.txt
echo "china-ip-full.txt has been generated"

# Clean up
rm "$local_file"
