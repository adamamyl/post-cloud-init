#!/bin/bash
# Generate /etc/issue for pre-login: hostname + network table, no color
set -e

HOSTNAME=$(hostname)
OUTPUT=$( /etc/update-motd.d/99-cloudinit-net | sed 's/\x1b\[[0-9;]*m//g' )

{
    echo "This is: $HOSTNAME"
    echo ""
    echo "$OUTPUT"
} > /etc/issue
