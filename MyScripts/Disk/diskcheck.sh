#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo -e "\033[1;31m❌ Vui lòng chạy lệnh này với sudo: sudo $0\033[0m"
  exit 1
fi

DRIVE="/dev/nvme0n1"
SMART_INFO=$(smartctl -a "$DRIVE" 2>/dev/null)

# Bóc tách toàn bộ thông số SSD chỉ trong 1 lần gọi awk duy nhất
eval "$(echo "$SMART_INFO" | awk -F ':' '
  function trim(s) { gsub(/^[ \t]+|[ \t]+$/, "", s); return s }
  /Model Number:/ { printf "MODEL=\"%s\"\n", trim($2) }
  /Firmware Version:/ { printf "FIRMWARE=\"%s\"\n", trim($2) }
  /NVMe Version:/ { printf "NVME_VER=\"%s\"\n", trim($2) }
  /overall-health self-assessment/ { printf "HEALTH=\"%s\"\n", trim($2) }
  /Available Spare:/ && !/Threshold/ { printf "SPARE=\"%s\"\n", trim($2) }
  /Percentage Used:/ { printf "USED=\"%s\"\n", trim($2) }
  /Media and Data Integrity Errors:/ { printf "ERRORS=\"%s\"\n", trim($2) }
  /Self-test status:/ { printf "SELF_TEST=\"%s\"\n", trim($2) }
  /Power On Hours:/ { printf "HOURS=\"%s\"\n", trim($2) }
  /Power Cycles:/ { printf "CYCLES=\"%s\"\n", trim($2) }
  /Unsafe Shutdowns:/ { printf "UNSAFE=\"%s\"\n", trim($2) }
  /Controller Busy Time:/ { printf "BUSY=\"%s\"\n", trim($2) }
  /^Temperature:/ { printf "TEMP=\"%s\"\n", trim($2) }
  /Warning  Comp. Temperature Time:/ { printf "WARN_TIME=\"%s\"\n", trim($2) }
  /Data Units Read:/ { match($2, /\[([^\]]+)\]/, a); printf "READ=\"%s\"\n", a[1] }
  /Data Units Written:/ { match($2, /\[([^\]]+)\]/, a); printf "WRITTEN=\"%s\"\n", a[1] }
')"

C="\033[1;36m"; G="\033[1;32m"; R="\033[1;31m"; Y="\033[1;33m"; Z="\033[0m"

[ "$HEALTH" = "PASSED" ] && CH=$G || CH=$R
[ "${ERRORS:-0}" = "0" ] && CE=$G || CE=$R
[ "${UNSAFE:-0}" -gt 0 ] 2>/dev/null && CU=$Y || CU=$G

echo -e "${C}╭────────────────────────────────────────╮${Z}"
echo -e "${C}│     THÔNG TIN SỨC KHỎE - NVMe SSD      │${Z}"
echo -e "${C}╰────────────────────────────────────────╯${Z}"
echo -e "${Y}▶ THÔNG TIN PHẦN CỨNG${Z}"
echo -e "  ▪ Thiết bị:    $MODEL (NVMe v$NVME_VER)"
echo -e "  ▪ Firmware:    $FIRMWARE\n"
echo -e "${Y}▶ TRẠNG THÁI SỨC KHỎE${Z}"
echo -e "  ▪ Đánh giá:    ${CH}$HEALTH${Z}"
echo -e "  ▪ Lỗi vật lý:  ${CE}$ERRORS${Z} (Lỗi toàn vẹn dữ liệu)"
echo -e "  ▪ Ô nhớ gốc:   $SPARE (Quỹ lưu trữ dự phòng)"
echo -e "  ▪ Độ hao mòn:  $USED"
echo -e "  ▪ Self-test:   $SELF_TEST\n"
echo -e "${Y}▶ THỐNG KÊ HOẠT ĐỘNG${Z}"
echo -e "  ▪ Đọc / Ghi:   $READ / $WRITTEN"
echo -e "  ▪ Thời gian:   $HOURS giờ ($CYCLES lần bật tắt)"
echo -e "  ▪ Tắt đột ngột:${CU} $UNSAFE lần${Z}"
echo -e "  ▪ Tải siêu nặng: $BUSY phút (Controller Busy Time)\n"
echo -e "${Y}▶ LỊCH SỬ NHIỆT ĐỘ${Z}"
echo -e "  ▪ Hiện tại:    $TEMP"
echo -e "  ▪ Quá nhiệt:   $WARN_TIME phút (Thời gian chạm mốc 90°C)\n"

# Đọc trực tiếp thông số Pin từ kernel /sys (không cần upower)
BAT="/sys/class/power_supply/BAT0"
if [ -d "$BAT" ]; then
  B_VENDOR=$(cat "$BAT/manufacturer" 2>/dev/null)
  B_MODEL=$(cat "$BAT/model_name" 2>/dev/null)
  B_STATE=$(cat "$BAT/status" 2>/dev/null)
  B_PERCENT=$(cat "$BAT/capacity" 2>/dev/null)
  B_CYCLES=$(cat "$BAT/cycle_count" 2>/dev/null || echo "N/A")
  START_THRESH=$(cat "$BAT/charge_control_start_threshold" 2>/dev/null || echo "N/A")
  END_THRESH=$(cat "$BAT/charge_control_end_threshold" 2>/dev/null || echo "N/A")

  # Quy đổi uWh sang Wh và tính độ chai pin bằng 1 lệnh awk
  read -r B_DESIGN B_CURRENT B_HEALTH <<< "$(awk -v d="$(cat "$BAT/energy_full_design" 2>/dev/null || cat "$BAT/charge_full_design" 2>/dev/null)" \
                                                   -v f="$(cat "$BAT/energy_full" 2>/dev/null || cat "$BAT/charge_full" 2>/dev/null)" \
                                                   'BEGIN { if(d>0) printf "%.2fWh %.2fWh %.1f%%", d/1000000, f/1000000, (f/d)*100; else print "N/A N/A N/A" }')"

  echo -e "${C}==========================================${Z}"
  echo -e "${Y} 🔋 THỐNG KÊ PIN HỆ THỐNG - $B_VENDOR $B_MODEL ${Z}"
  echo -e "${C}==========================================${Z}"
  echo -e "Trạng thái sạc       : ${G}$B_STATE${Z}"
  echo -e "Phần trăm pin        : ${G}$B_PERCENT%${Z}"
  echo -e "Tuổi thọ (Health)    : ${Y}$B_HEALTH${Z}"
  echo -e "Số chu kỳ sạc (Cycle): $B_CYCLES"
  echo -e "------------------------------------------"
  echo -e "Dung lượng thiết kế  : $B_DESIGN"
  echo -e "Dung lượng tối đa    : $B_CURRENT"
  echo -e "Ngưỡng sạc tự động   : Bắt đầu ở $START_THRESH, Dừng ở $END_THRESH"
  echo -e "${C}==========================================${Z}"
fi

echo -e "\n${C}Nhấn phím Enter để thoát...${Z}"
read -r
