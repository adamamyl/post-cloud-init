#!/bin/bash
# Generate /etc/issue from MOTD (color-stripped)

MOTD_SCRIPT=/etc/update-motd.d/99-cloudinit-net

"$MOTD_SCRIPT" | sed 's/\x1b\[[0-9;]*m//g' | tee /etc/issue >/dev/null
