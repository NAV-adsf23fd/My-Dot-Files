#!/usr/bin/env bash
set -u
source "$HOME/Applications/Config/MyScripts/Theme/colors.sh"

APP_FILE="$(dirname "$(readlink -f "$0")")/my_apps.txt"

[ -f "$APP_FILE" ] || touch "$APP_FILE"

CHOICE=$(cut -d':' -f1 "$APP_FILE" | grep -v '^$' | dmenu \
    -i \
    -p ">" \
    -nb "$BACKGROUND" \
    -nf "$HIGHLIGHT" \
    -sb "$HIGHLIGHT" \
    -sf "$BACKGROUND")

[ -z "$CHOICE" ] && exit 0

COMMAND=$(awk -F':' -v app="$CHOICE" '$1==app {print $2}' "$APP_FILE")

[ -n "$COMMAND" ] && exec sh -c "$COMMAND" >/dev/null 2>&1
