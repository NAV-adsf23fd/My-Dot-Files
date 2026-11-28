#!/bin/sh

BASE_DIR="$(cd "$(dirname "$(readlink -f "$0")")" && pwd)"
ART_DIR="$BASE_DIR/artlist"
TARGET_LINK="$BASE_DIR/art.txt"

if [ -z "$1" ]; then
    echo "Usage: $(basename "$0") <file name>"
    echo "artlist:"
    ls -1 "$ART_DIR"
    exit 1
fi

# Allow .txt or none-txt
INPUT_NAME="$1"
if [ -f "$ART_DIR/$INPUT_NAME" ]; then
    CHOSEN_FILE="$ART_DIR/$INPUT_NAME"
elif [ -f "$ART_DIR/$INPUT_NAME.txt" ]; then
    CHOSEN_FILE="$ART_DIR/$INPUT_NAME.txt"
else
    echo "[ERROR]: Cannot find '$INPUT_NAME' in $ART_DIR"
    exit 1
fi

# symlink
ln -sf "artlist/$(basename "$CHOSEN_FILE")" "$TARGET_LINK"

# do not need "&", colored_art_bg exit automatically
cd "$BASE_DIR" && ./colored_art_bg

echo "Changed background to: $(basename "$CHOSEN_FILE")"
