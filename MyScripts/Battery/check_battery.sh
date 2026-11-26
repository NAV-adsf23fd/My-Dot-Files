#!/bin/bash

export DISPLAY="${DISPLAY:-:0}"
export XAUTHORITY="${XAUTHORITY:-$HOME/.Xauthority}"

TERMINAL="${DEFAULT_TERMINAL}"
BAT_PATH=$(echo /sys/class/power_supply/BAT* | awk '{print $1}')
LOCK_FILE="/tmp/battery_warned"

# Thoát ngay nếu máy không có pin (ví dụ dùng máy bàn)
[ -d "$BAT_PATH" ] || exit 0

BATTERY_LEVEL=$(cat "$BAT_PATH/capacity")
CHARGING_STATUS=$(cat "$BAT_PATH/status")

# Đang cắm sạc hoặc pin đầy thì xóa cờ và thoát
if [ "$CHARGING_STATUS" = "Charging" ] || [ "$CHARGING_STATUS" = "Full" ]; then
    rm -f "$LOCK_FILE"
    exit 0
fi

# =====================================================================
# 1. MỨC CẢNH BÁO (Từ 31% đến 35%)
# =====================================================================
# if [ "$BATTERY_LEVEL" -le 35 ] && [ "$BATTERY_LEVEL" -gt 30 ]; then
#     if [ ! -f "$LOCK_FILE" ]; then
#         "$TERMINAL" -t "BatteryWarning" -e sh -c "printf '\n\tCẢNH BÁO PIN: %s%%\n\tHãy cắm sạc ngay.\n' '$BATTERY_LEVEL'; read -r _"
#         touch "$LOCK_FILE"
#     fi
# fi

# =====================================================================
# 2. MỨC KHẨN CẤP (Dưới hoặc bằng 30%) -> BẮT BUỘC SUSPEND
# =====================================================================
if [ "$BATTERY_LEVEL" -le 30 ]; then
    # "$TERMINAL" -t "BatteryCritical" -e sh -c "printf '\n\tPIN CẠN KIỆT: %s%%\n\tHệ thống sẽ Suspend sau 3 giây...\n' '$BATTERY_LEVEL'; sleep 3"
    exec systemctl suspend
fi
