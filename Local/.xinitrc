#!/bin/sh

# IME (fcitx5)
export GTK_IM_MODULE=fcitx5
export QT_IM_MODULE=fcitx5
export XMODIFIERS=@im=fcitx5
fcitx5 &

# XDG (minimal correct)
export XDG_CURRENT_DESKTOP=dwm
export XDG_SESSION_TYPE=x11

# optional portals (chỉ nếu cần flatpak)
/usr/lib/xdg-desktop-portal &
/usr/lib/xdg-desktop-portal-gtk &

# wallpaper
cd "$HOME/Applications/Config/MyScripts/DesktopBackground"
./colored_art_bg # dont need & becouse colored_art_bg auto exit
cd ~

# status bar
dwmblocks &

# input config
"$HOME/Applications/Config/MyScripts/Input/set_custom_input.sh" &

# start window manager
picom -b

systemctl --user import-environment DEFAULT_TERMINAL DEFAULT_EDITOR DEFAULT_BROWSER DEFAULT_FILE_MANAGER DISPLAY XAUTHORITY

exec dwm