// Ký tự phân cách (1 khoảng trắng)
#define DELIMITER " "

// Độ dài tối đa của output
#define MAX_BLOCK_OUTPUT_LENGTH 45

// BẬT tính năng click chuột (Cái này cực kỳ quan trọng để script của bạn nhận click)
#define CLICKABLE_BLOCKS 1

// Bỏ các khoảng trắng thừa ở đầu và cuối
#define LEADING_DELIMITER 0
#define TRAILING_DELIMITER 0

// Cấu hình các block bằng Macro theo đúng chuẩn của bản này
#define BLOCKS(X) \
    X("", "~/Applications/Config/MyScripts/WindowManager/scripts/statusbar/sb-volume.sh",  0,  10) \
    X("", "~/Applications/Config/MyScripts/WindowManager/scripts/statusbar/sb-battery.sh", 60, 11) \
    X("", "~/Applications/Config/MyScripts/WindowManager/scripts/statusbar/sb-wifi.sh",    10, 12) \
    X("", "~/Applications/Config/MyScripts/WindowManager/scripts/statusbar/sb-time.sh",    5,  0) \
    X("", "~/Applications/Config/MyScripts/WindowManager/scripts/statusbar/sb-power.sh",   0,  13)
