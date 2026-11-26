#!/bin/bash

THEME_DIR="$HOME/Applications/Config/MyScripts/Theme"
DWM_DIR="$HOME/Applications/Config/MyScripts/WindowManager/dwm-6.4"
ST_DIR="$HOME/Applications/Config/MyScripts/Terminal/st"
BG_DIR="$HOME/Applications/Config/MyScripts/DesktopBackground"

gcc "$BG_DIR/colored_art_bg.c" -o "$BG_DIR/colored_art_bg" -lX11
make -C "$DWM_DIR" clean && make -C "$DWM_DIR" && sudo make -C "$DWM_DIR" install
make -C "$ST_DIR" clean && make -C "$ST_DIR" && sudo make -C "$ST_DIR" install