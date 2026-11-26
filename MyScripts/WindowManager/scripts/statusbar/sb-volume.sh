#!/bin/sh

case $BLOCK_BUTTON in
    1)  pactl set-sink-mute @DEFAULT_SINK@ toggle ;;
    3)  pavucontrol ;; 
    4) 
        pactl set-sink-volume @DEFAULT_SINK@ +5%
        # Phanh lại nếu lố 100%
        new_vol=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -Po '[0-9]+(?=%)' | head -n 1)
        if [ "$new_vol" -gt 100 ]; then
            pactl set-sink-volume @DEFAULT_SINK@ 100%
        fi
        ;; 
    5) pactl set-sink-volume @DEFAULT_SINK@ -5% ;;
esac

vol=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -Po '[0-9]+(?=%)' | head -n 1)
mute=$(pactl get-sink-mute @DEFAULT_SINK@ | grep -Po 'yes')

if [ "$mute" = "yes" ]; then
    echo " ^c#E06C75^M^d^ " 
else
    echo "^c#7A7699^${vol}%^d^"
fi