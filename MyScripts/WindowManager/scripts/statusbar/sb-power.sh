#!/bin/sh

# File lưu trạng thái: 0=N, 1=S, 2=T, 3=R
STATE_FILE="/tmp/sb_power_state"
[ ! -f "$STATE_FILE" ] && echo 0 > "$STATE_FILE"
state=$(cat "$STATE_FILE")

case $BLOCK_BUTTON in
    4) state=$(( (state + 1) % 4 )) ;; # Cuộn lên
    5) state=$(( (state - 1) % 4 )); [ $state -lt 0 ] && state=3 ;; # Cuộn xuống
    1) # Click trái
       case $state in
           1) systemctl suspend ;;
           2) systemctl poweroff ;;
           3) systemctl reboot ;;
       esac
       state=0 # Reset về N sau khi click (tránh lần sau click nhầm)
       ;;
esac

# Lưu lại trạng thái mới
echo $state > "$STATE_FILE"

# In ra màu tương ứng
case $state in
    0) echo "^c#7A7699^N^d^" ;; # Màu xám mờ cho None
    1) echo "^c#F2E9D8^S^d^" ;; #  (Sleep)
    2) echo "^c#E06C75^T^d^" ;; #  (Tắt)
    3) echo "^c#8FE388^R^d^" ;; #  (Restart)
esac