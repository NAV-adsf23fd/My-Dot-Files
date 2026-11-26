#!/bin/sh

TOUCHPAD="DELL0A36:00 06CB:CE65 Touchpad"
MOUSE="PixA琀 USB Optical Mouse"

# TOUCHPAD
xinput set-prop "$TOUCHPAD" \
"libinput Tapping Enabled" 1

xinput set-prop "$TOUCHPAD" \
"libinput Click Method Enabled" 0 1

xinput set-prop "$TOUCHPAD" \
"libinput Natural Scrolling Enabled" 0

xinput set-prop "$TOUCHPAD" \
"libinput Accel Speed" 0.6

xinput set-prop "$TOUCHPAD" \
"libinput Disable While Typing Enabled" 1

xinput set-prop "$TOUCHPAD" \
"libinput Tapping Drag Enabled" 1


# MOUSE
xinput set-prop "$MOUSE" \
"libinput Accel Speed" 1