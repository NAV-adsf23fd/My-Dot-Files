#!/usr/bin/env bash
set -u
source "$HOME/Applications/Config/MyScripts/Theme/colors.sh"


# File lưu trạng thái: 0=N, 1=S, 2=T, 3=R
STATE_FILE="/tmp/sb_power_state"
[ ! -f "$STATE_FILE" ] && echo 0 > "$STATE_FILE"
state=$(cat "$STATE_FILE")

case "${BLOCK_BUTTON:-}" in
    4) state=$(( (state + 1) % 4 )) ;; # Cuộn lên
    5) state=$(( (state - 1) % 4 )); [ $state -lt 0 ] && state=3 ;; # Cuộn xuống
    1) # Click trái
       case $state in
           1)
              echo 0 > "$STATE_FILE" # Reset về None 
              systemctl suspend
              ;;
           2)
              echo 0 > "$STATE_FILE"
              killall -q picom dwmblocks
              systemctl poweroff
              ;;
           3)
              echo 0 > "$STATE_FILE"
              killall -q picom dwmblocks
              systemctl reboot
              ;;
       esac
       state=0 # Reset về None 
       ;;

esac

# Lưu lại trạng thái mới
echo $state > "$STATE_FILE"

# In ra màu tương ứng
case $state in
    0) echo "^c${DC1_1}^N^d^" ;; # None
    1) echo "^c${DC1_2}^S^d^" ;; # Sleep
    2) echo "^c${DC1_3}^T^d^" ;; # Poweroff
    3) echo "^c${DC1_4}^R^d^" ;; # Reboot
esac