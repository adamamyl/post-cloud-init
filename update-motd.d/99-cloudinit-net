#!/bin/bash
# Cloud-init style MOTD: dual-stack network + primary interface + system info

CYAN="\033[1;36m"
BOLD_CYAN="\033[1;36;1m"
YELLOW="\033[1;33m"
GREEN="\033[1;32m"
BOLD_GREEN="\033[1;32;1m"
MAGENTA="\033[1;35m"
BLUE="\033[1;34m"
RESET="\033[0m"

MAX_ADDR_WIDTH=45

HOSTNAME=$(hostname)
OS_NAME=$(lsb_release -d | cut -f2)
KERNEL=$(uname -r)
UPTIME=$(uptime -p)

PRIMARY_IFACE=$(ip route get 1.1.1.1 | awk '{for(i=1;i<=NF;i++){if($i=="dev"){print $(i+1); exit}}}')
PUBLIC_IP4=$(ip -4 addr show dev "$PRIMARY_IFACE" | awk '{print $2}' | grep -v -E '^10\.|^172\.(1[6-9]|2[0-9]|3[0-1])\.|^192\.168\.' | head -n1)
PUBLIC_IP6=$(ip -6 addr show dev "$PRIMARY_IFACE" | awk '{print $2}' | grep -v '^fe80:' | head -n1)

print_row() {
    local iface="$1"
    local state="$2"
    local addr="$3"
    local color="$4"
    printf "| %-14s | %-7s | %-30s |\n" "$color$iface$RESET" "$color$state$RESET" "$color$addr$RESET"
}

printf "${BLUE}Welcome to %s (${OS_NAME})${RESET}\n" "$HOSTNAME"
printf "Kernel: %s | Uptime: %s\n\n" "$KERNEL" "$UPTIME"

printf "+----------------+---------+--------------------------------+\n"
printf "| Interface      | State   | Addresses                      |\n"
printf "+----------------+---------+--------------------------------+\n"

ip -brief addr show | while read iface state addrs; do
    if [[ "$iface" == "$PRIMARY_IFACE" ]]; then
        iface_display="${MAGENTA}${iface}*${RESET}"
    else
        iface_display="$iface"
    fi

    IFS=' ' read -r -a addr_array <<< "$addrs"
    first_line=true
    line_addr=""

    for addr in "${addr_array[@]}"; do
        if [[ "$addr" == "$PUBLIC_IP4"* ]]; then
            addr_color=$BOLD_GREEN
        elif [[ "$addr" == "$PUBLIC_IP6"* ]]; then
            addr_color=$BOLD_CYAN
        elif [[ $addr == *:* ]]; then
            addr_color=$CYAN
        else
            addr_color=$GREEN
        fi

        if [ ${#line_addr} -eq 0 ]; then
            line_addr="$addr"
        else
            if [ $((${#line_addr}+${#addr}+3)) -gt $MAX_ADDR_WIDTH ]; then
                if $first_line; then
                    print_row "$iface_display" "$state" "$line_addr" "$addr_color"
                    first_line=false
                else
                    print_row "" "" "$line_addr" "$addr_color"
                fi
                line_addr="$addr"
            else
                line_addr="$line_addr | $addr"
            fi
        fi
    done

    if $first_line; then
        print_row "$iface_display" "$state" "$line_addr" "$addr_color"
    else
        print_row "" "" "$line_addr" "$addr_color"
    fi
done

printf "+----------------+---------+--------------------------------+\n"

TOTAL_MEM=$(free -h | awk '/^Mem:/ {print $2}')
USED_MEM=$(free -h | awk '/^Mem:/ {print $3}')
DISK=$(df -h / | awk 'NR==2 {print $2 " total, " $3 " used"}')
printf "\nMemory: %s used / %s total | Disk: %s\n" "$USED_MEM" "$TOTAL_MEM" "$DISK"
