# DWM -------------------------------------

export HIGHLIGHT="#b5b5b5"      # Nâng từ #7a7a7a -> Xám sáng dịu, đọc cực rõ ở độ sáng màn hình thấp
export SUB_HIGHLIGHT="#858585"  # Nâng từ #636363 -> Đủ rõ cho trạng thái phụ và comment

export BACKGROUND="#000000"     # Giữ nguyên đen tuyệt đối
export SUB_BACKGROUND="#262626" # Nhích nhẹ từ #242424 để tách khối nhẹ trên nền đen


# Static Colors (Giữ sắc độ trầm ấm nhưng nâng độ sáng để nổi trên nền đen)
export YELLOW="#a8b078"         # Nâng từ #686e48 -> Vàng ô-liu sáng dịu
export BLUE="#74a3a3"           # Nâng từ #436666 -> Xanh cổ vịt sáng dịu
export GREEN="#88bf80"          # Nâng từ #6da165 -> Xanh rêu sáng dịu
export RED="#a87474"            # Nâng từ #5c4242 -> Đỏ đất trầm nhưng dễ nhìn

# Dynamic Colors 1
export DC1_1="${SUB_HIGHLIGHT}"
export DC1_2="${YELLOW}"
export DC1_3="${GREEN}"
export DC1_4="${RED}"

# Dynamic Colors 2
export DC2_1="${GREEN}"
export DC2_2="${RED}"
export DC2_3="#98bd93"          # Nâng từ #779473

# Dynamic Colors 3
export DC3_1="${RED}"
export DC3_2="${SUB_HIGHLIGHT}"

# Dynamic Colors 4
export DC4_1="${RED}"
export DC4_2="${SUB_HIGHLIGHT}"


# ST ---------------------------------------
# 8 màu normal (đồng bộ trực tiếp với nhóm Static đã nâng tương phản)
export COLOR0="${SUB_BACKGROUND}" # #262626 - black
export COLOR1="${RED}"            # #a87474 - red
export COLOR2="${GREEN}"          # #88bf80 - green
export COLOR3="${YELLOW}"         # #a8b078 - yellow
export COLOR4="${BLUE}"           # #74a3a3 - blue
export COLOR5="#9e7a9a"           # magenta (tím khói nâng sáng)
export COLOR6="#78ab9f"           # cyan (xanh ngọc trầm nâng sáng)
export COLOR7="${HIGHLIGHT}"      # #b5b5b5 - white

# 8 màu bright (nâng thêm ~15% độ sáng cho từ khóa, tiêu đề, thông báo nổi bật)
export COLOR8="${SUB_HIGHLIGHT}"  # #858585 - bright black (comment, chữ mờ)
export COLOR9="#c79191"           # bright red
export COLOR10="#a6d99e"          # bright green
export COLOR11="#c7cf95"          # bright yellow
export COLOR12="#91c2c2"          # bright blue
export COLOR13="#bd97b8"          # bright magenta
export COLOR14="#95c9bd"          # bright cyan
export COLOR15="#d4d4d4"          # bright white (chữ chính trong code/terminal)

# Màu hệ thống (st)
export ST_BG="${BACKGROUND}"
export ST_FG="${HIGHLIGHT}"       # #b5b5b5 - Chữ mặc định terminal rõ nét
export ST_CURSOR="${HIGHLIGHT}"         # #a87474 - Con trỏ dễ tìm vị trí hơn hẳn #5c4242 cũ
export ST_SEL_BG="${SUB_BACKGROUND}"
export ST_SEL_FG="${COLOR15}"     # #d4d4d4 - Chữ khi bôi đen nổi bật rõ ràng


# GTK ----------------------------
export LINE_BG="#2e2e2e"
export SELECTION_BG="#3d3d3d"
