#!/usr/bin/env bash
set -u
source "$HOME/Applications/Config/MyScripts/Theme/colors.sh"


STATE="/tmp/redshift_state"

case "${BLOCK_BUTTON:-}" in
    1)
        if [ -f "$STATE" ]; then
            # đang bật → tắt (reset màu)
            redshift -x
            rm -f "$STATE"
        else
            # đang tắt → bật
            redshift -O 4000
            touch "$STATE"
        fi
        ;;
    3)
        x-terminal-emulator -e batt-tool
        ;;
    4)
        brightnessctl set +5% > /dev/null
        ;;
    5)
        MIN_BRIGHT=1
        CURRENT_BRIGHT=$(brightnessctl -m | cut -d, -f4 | tr -d '%')
        NEW_BRIGHT=$((CURRENT_BRIGHT - 5))
        
        if [ "$NEW_BRIGHT" -lt "$MIN_BRIGHT" ]; then
            brightnessctl set "${MIN_BRIGHT}%" > /dev/null
        else
            brightnessctl set 5%- > /dev/null
        fi
        ;;
esac

BAT_PATH="/sys/class/power_supply/BAT0"

if [ -r "$BAT_PATH/capacity" ]; then
    val=$(cat "$BAT_PATH/capacity")
    status=$(cat "$BAT_PATH/status")

    if [ "$status" = "Charging" ]; then
        echo "^c${DC2_1}^${val}%^d^"
    elif [ "$val" -le 30 ]; then
        echo "^c${DC2_2}^${val}%^d^"
    else
        echo "^c${DC2_3}^${val}%^d^"
    fi
else
    echo "No Battery"
fi