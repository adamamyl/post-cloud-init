#!/bin/bash
# Generate /etc/issue from MOTD (no color)
MOTD_SCRIPT=/etc/update-motd.d/99-cloudinit-net

"$MOTD_SCRIPT" --no-color | tee /etc/issue >/dev/null
