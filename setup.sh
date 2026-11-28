#!/bin/bash

DWM_DIR="$HOME/Applications/Config/MyScripts/WindowManager/dwm-6.4"
ST_DIR="$HOME/Applications/Config/MyScripts/Terminal/st"
BG_DIR="$HOME/Applications/Config/MyScripts/DesktopBackground"
MSHOT_DIR="$HOME/Applications/Config/MyScripts/Mshot"
OP_DIR="$HOME/Applications/Config/MyScripts/OpenFile"
APPM_DIR="$HOME/Applications/Config/MyScripts/AppMenu"
AURCHEK_DIR="$HOME/Applications/Config/MyScripts/AurCheck"

echo "=== Compiling ==="
$MSHOT_DIR/compile.sh && echo "[OK] Mshot"    || echo "[LỖI] Mshot"
$BG_DIR/compile.sh  && echo "[OK] ChangeBg"  || echo "[LỖI] ChangeBg"
make -C "$DWM_DIR" clean && make -C "$DWM_DIR" && sudo make -C "$DWM_DIR" install && echo "[OK] DWM"  || echo "[LỖI] DWM"
make -C "$ST_DIR" clean && make -C "$ST_DIR" && sudo make -C "$ST_DIR" install && echo "[OK] ST"  || echo "[LỖI] ST"

echo "=== Creating Symlink ==="
$MSHOT_DIR/create_symlink.sh    && echo "[OK] Mshot"    || echo "[LỖI] Mshot"
$OP_DIR/create_symlink.sh && echo "[OK] OpenFile" || echo "[LỖI] OpenFile"
$APPM_DIR/create_symlink.sh  && echo "[OK] AppMenu"  || echo "[LỖI] AppMenu"
$BG_DIR/create_symlink.sh  && echo "[OK] ChangeBg"  || echo "[LỖI] ChangeBg"
$AURCHEK_DIR/create_symlink.sh && echo "[OK] AurCheck"  || echo "[LỖI] AurCheck"