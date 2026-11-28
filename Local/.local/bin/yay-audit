#!/bin/bash

DIFF_TMP=$(mktemp)
cat > "$DIFF_TMP"

{
    echo -e "\033[1;36m================ [ KIỂM TRA BẢO MẬT PKGBUILD ] ================\033[0m"
    
    if [ -f "PKGBUILD" ]; then
        echo -e "\033[1;33m[*] Đang chạy namcap kiểm tra cấu trúc...\033[0m"
        namcap PKGBUILD
    fi

    echo -e "\033[1;33m[*] Đang quét lệnh nguy hiểm (curl, wget, base64, eval, rm -rf)...\033[0m"
    SUSPICIOUS=$(grep -E '^\+.*(curl|wget|base64|eval|nc |bash -i|/dev/tcp|chmod 777|rm -rf /)' "$DIFF_TMP")
    
    if [ -n "$SUSPICIOUS" ]; then
        echo -e "\033[1;31m[CẢNH BÁO] Phát hiện lệnh đáng ngờ:\033[0m"
        echo "$SUSPICIOUS"
    else
        echo -e "\033[1;32m[OK] Không phát hiện từ khóa độc hại phổ biến.\033[0m"
    fi

    echo -e "\033[1;36m==============================================================\033[0m\n"
    
    cat "$DIFF_TMP"
} | less -R

rm -f "$DIFF_TMP"
