#!/bin/bash

if [ -z "$1" ]; then
    echo "Lỗi: chưa nhập file hoặc link"
    exit 1
fi

TARGET="$1"
# Chuyển sang chữ thường trực tiếp bằng Bash (không cần gọi tiến trình phụ echo | tr)
TARGET_LOWER="${TARGET,,}"

# Dùng biến mặc định đã khai báo trong .profile
TERMINAL="${DEFAULT_TERMINAL:-st}"
BROWSER="${DEFAULT_BROWSER:-$HOME/Applications/Linux/WaterFox/waterfox/waterfox}"
EDITOR=subl

# 1. Xử lý riêng nếu là thư mục (kể cả khi gõ tên thư mục không có dấu / ở cuối)
if [ -d "$TARGET" ]; then
    exec xfe "$TARGET" >/dev/null 2>&1
fi

# 2. Xử lý theo đuôi file hoặc link
case "$TARGET_LOWER" in
    # Web / HTML / Video / Audio / PDF
    http://*|https://*|*.html|*.htm|*.mp4|*.mkv|*.avi|*.mp3|*.wav|*.m4a|*.ogg|*.mov|*.pdf|*.doc|*.pptx)
        exec "$BROWSER" "$TARGET" >/dev/null 2>&1
        ;;

    # Ảnh
    *.jpg|*.jpeg|*.svg|*.png|*.gif|*.bmp|*.webp)
        exec google-chrome-stable "$TARGET" >/dev/null 2>&1
        ;;

    # File nén Zip
    *.zip)
        exec "$TERMINAL" -e bash -c 'unzip -l "$1"; read -rp "Press Enter to exit..."' -- "$TARGET" >/dev/null 2>&1
        ;;

    # Pixel Art
    *.pxo|*.aseprite)
        exec "$HOME/Applications/Linux/Pixelorama/Pixelorama.x86_64" "$TARGET" >/dev/null 2>&1
        ;;

    # Code / Text
    *.txt|*.c|*.cpp|*.py|*.h|*.sh|*.conf|*.json|*rc|*sublime*|*.md|*.srt)
        exec "$EDITOR" "$TARGET" >/dev/null 2>&1
        ;;

    # Trường hợp khác -> Kiểm tra MIME
    *)
        MIME=$(file --mime-type -Lb "$TARGET" 2>/dev/null)
        if [[ "$MIME" == text/* ]]; then
            exec "$EDITOR" "$TARGET" >/dev/null 2>&1
        else
            exec "$TERMINAL" -e bash -c "read -rp 'Không biết mở file này bằng gì (MIME: $MIME)'"
        fi
        ;;
esac
