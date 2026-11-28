#!/usr/bin/env bash
THEME_DIR="$HOME/Applications/Config/MyScripts/Theme"
DWM_DIR="$HOME/Applications/Config/MyScripts/WindowManager/dwm-6.4"
ST_DIR="$HOME/Applications/Config/MyScripts/Terminal/st"
BG_DIR="$HOME/Applications/Config/MyScripts/DesktopBackground"
SUBLIME_DIR="$HOME/.config/sublime-text/Packages/User"
GTK3_DIR="$HOME/Applications/Config/Local/.config/gtk-3.0"
GTK4_DIR="$HOME/Applications/Config/Local/.config/gtk-4.0"
WATERFOX_DIR="$HOME/Applications/Config/Local/.waterfox/mainprofile/chrome"



# Nạp biến màu từ colors.sh
source "$THEME_DIR/colors.sh"

# Render từ template
envsubst < "$THEME_DIR/dwm_theme.h.template" > "$DWM_DIR/theme.h"
envsubst < "$THEME_DIR/st_theme.h.template" > "$ST_DIR/theme.h"
envsubst < "$THEME_DIR/bg_theme.h.template" > "$BG_DIR/theme.h"
envsubst < "$THEME_DIR/sublime.color-scheme.template" > "$SUBLIME_DIR/MyDynamicTheme.sublime-color-scheme"
envsubst < "$THEME_DIR/sublime.theme.template" > "$SUBLIME_DIR/Adaptive.sublime-theme"
envsubst < "$THEME_DIR/gtk.css.template" > "$GTK3_DIR/gtk.css"
envsubst < "$THEME_DIR/gtk.css.template" > "$GTK4_DIR/gtk.css"
envsubst < "$THEME_DIR/waterfox-colors.css.template" > "$WATERFOX_DIR/theme-colors.css"