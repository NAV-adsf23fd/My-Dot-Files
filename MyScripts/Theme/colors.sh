# DWM -------------------------------------

export HIGHLIGHT="#959595"      # Tương phản đúng 7.01:1 trên #000000 (chữ chính)
export SUB_HIGHLIGHT="#787878"  # Tương phản ~4.76:1 (chữ phụ, comment, tab nền)

export BACKGROUND="#000000"     # Giữ nguyên nền đen tuyệt đối
export SUB_BACKGROUND="#242424" # Nền nổi nhẹ cho vùng chọn / tab active


# Static Colors (Tất cả đều được cân bằng quanh ngưỡng 6:1 - 7.1:1)
export YELLOW="#91966d"         # ~6.79:1 - Vàng ô-liu trầm dịu
export BLUE="#6e9494"           # ~6.33:1 - Xanh cổ vịt trầm
export GREEN="#76a170"          # ~7.10:1 - Xanh rêu dịu
export RED="#ad7878"            # ~5.73:1 - Đỏ đất trầm (giảm bão hòa để không chói)

# Dynamic Colors 1
export DC1_1="${SUB_HIGHLIGHT}"
export DC1_2="${YELLOW}"
export DC1_3="${GREEN}"
export DC1_4="${RED}"

# Dynamic Colors 2
export DC2_1="${GREEN}"
export DC2_2="${RED}"
export DC2_3="#7fa37a"          # ~7.42:1

# Dynamic Colors 3
export DC3_1="${RED}"
export DC3_2="${SUB_HIGHLIGHT}"

# Dynamic Colors 4
export DC4_1="${RED}"
export DC4_2="${SUB_HIGHLIGHT}"


# ST ---------------------------------------
# 8 màu normal (đồng bộ trực tiếp với nhóm Static ~6:1 - 7.1:1)
export COLOR0="${SUB_BACKGROUND}" # #242424 - black
export COLOR1="${RED}"            # #ad7878 - red
export COLOR2="${GREEN}"          # #76a170 - green
export COLOR3="${YELLOW}"         # #91966d - yellow
export COLOR4="${BLUE}"           # #6e9494 - blue
export COLOR5="#9e7c9b"           # ~5.81:1 - magenta (tím khói trầm)
export COLOR6="#6f9c92"           # ~6.85:1 - cyan (xanh ngọc trầm)
export COLOR7="${HIGHLIGHT}"      # #959595 - white

# 8 màu bright (nhích nhẹ lên ~7.5:1 - 8.2:1 để phân biệt với normal mà không gắt)
export COLOR8="${SUB_HIGHLIGHT}"  # #787878 - bright black
export COLOR9="#bd8888"           # ~7.04:1 - bright red
export COLOR10="#83ad7d"          # ~8.24:1 - bright green
export COLOR11="#9ca176"          # ~7.77:1 - bright yellow
export COLOR12="#79a1a1"          # ~7.43:1 - bright blue
export COLOR13="#ab88a8"          # ~6.82:1 - bright magenta
export COLOR14="#7ba89e"          # ~7.94:1 - bright cyan
export COLOR15="#a1a1a1"          # ~8.13:1 - bright white (chữ sáng trong code/terminal)

# Màu hệ thống (st)
export ST_BG="${BACKGROUND}"
export ST_FG="${HIGHLIGHT}"       # #959595 - Chữ mặc định terminal đúng chuẩn 7:1
export ST_CURSOR="${HIGHLIGHT}"   # #959595 - Con trỏ xám trung tính đồng bộ
export ST_SEL_BG="${SUB_BACKGROUND}"
export ST_SEL_FG="${COLOR15}"     # #a1a1a1 - Chữ khi bôi đen rõ ràng, dịu mắt
