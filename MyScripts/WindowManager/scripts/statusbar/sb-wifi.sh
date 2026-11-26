#!/bin/sh

case $BLOCK_BUTTON in
    3) st -e nmtui ;;
esac

wifi_name=$(nmcli -t -f TYPE,NAME connection show --active | grep '802-11-wireless' | cut -d':' -f2)

if [ -n "$wifi_name" ]; then
    short_name=$(printf "%s" "$wifi_name" | cut -c 1-3)
    echo "^c#7A7699^$short_name^d^"
else
    echo "^c#7A7699^---^d^"
fi