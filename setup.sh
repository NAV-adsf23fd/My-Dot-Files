#!/bin/bash

echo "=== Creating Symlink ==="
./MyScripts/Mshot/create_symlink.sh    && echo "[OK] Mshot"    || echo "[LỖI] Mshot"
./MyScripts/OpenFile/create_symlink.sh && echo "[OK] OpenFile" || echo "[LỖI] OpenFile"
./MyScripts/AppMenu/create_symlink.sh  && echo "[OK] AppMenu"  || echo "[LỖI] AppMenu"
./MyScripts/DesktopBackground/create_symlink.sh  && echo "[OK] ChangeBg"  || echo "[LỖI] ChangeBg"

