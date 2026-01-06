#!/bin/sh

# 1. Delete the entire table
# This will automatically remove all chains (SHADOWSOCKS, prerouting, output),
# all rules within them, and all sets (chnroute, chnroute6).
nft delete table inet ss_nat 2>/dev/null

# 2. Optional: Verify deletion (No output means success)
# nft list table inet ss_nat
