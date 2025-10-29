## Dynamic MOTD script: 
 - `./etc/update-motd.d/99-cloudinit-net`
 - Dual-stack aware
 - Primary interface highlighted
 - Public IPv4 and global IPv6 highlighted
 - Wrapped table with multiple addresses
 - Footer with memory and disk info

## /etc/issue updater: 
  - `./usr/local/sbin/update-issue.sh`
  - Strips colors from MOTD output
  - Keeps /etc/issue up to date

## Systemd service: 
  - `./etc/systemd/system/update-issue.service`
  - Runs at boot to populate /etc/issue

## Installer helper: 
 - `.install.sh`
 - Copies scripts and service to correct locations
 - Sets permissions
 - Enables and starts the systemd service

# With this setup:
  - MOTD is dynamic on every login
  - /etc/issue is updated automatically at boot
  - Fully Ubuntu-compliant, cloud-init style, dual-stack aware