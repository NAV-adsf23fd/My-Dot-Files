#!/bin/sh

# Tự động lấy đường dẫn tuyệt đối của thư mục chứa script này
BASE_DIR="$(cd "$(dirname "$(readlink -f "$0")")" && pwd)"
ART_DIR="$BASE_DIR/artlist"
TARGET_LINK="$BASE_DIR/art.txt"

# Nếu chạy không truyền tham số -> In ra danh sách các file có sẵn để dễ chọn
if [ -z "$1" ]; then
    echo "Cách dùng: $(basename "$0") <tên_file>"
    echo "Danh sách hình nền có sẵn trong artlist:"
    ls -1 "$ART_DIR"
    exit 1
fi

# Cho phép gõ tên có đuôi .txt hoặc không cần gõ đuôi .txt đều nhận
INPUT_NAME="$1"
if [ -f "$ART_DIR/$INPUT_NAME" ]; then
    CHOSEN_FILE="$ART_DIR/$INPUT_NAME"
elif [ -f "$ART_DIR/$INPUT_NAME.txt" ]; then
    CHOSEN_FILE="$ART_DIR/$INPUT_NAME.txt"
else
    echo "Lỗi: Không tìm thấy '$INPUT_NAME' trong $ART_DIR"
    exit 1
fi

# Tạo symlink tương đối (artlist/ten_file.txt -> art.txt)
ln -sf "artlist/$(basename "$CHOSEN_FILE")" "$TARGET_LINK"

# Vẽ lại hình nền mới ngay lập tức, bản thân colored_art_bg đã tự thoát sau khi vẽ nên không cần kill
cd "$BASE_DIR" && ./colored_art_bg

echo "Đã đổi hình nền sang: $(basename "$CHOSEN_FILE")"
