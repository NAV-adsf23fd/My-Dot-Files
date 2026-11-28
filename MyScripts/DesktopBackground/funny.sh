#!/bin/bash

BASE_DIR="$(cd "$(dirname "$(readlink -f "$0")")" && pwd)"
cd "$BASE_DIR" || exit 1

trap "echo -e '\nEnd!'; exit 0" SIGINT

echo "Yes, so funny"

show_frame() {
    ln -sf "$1" "$BASE_DIR/art.txt"
    "$BASE_DIR/colored_art_bg"
    sleep "$2"
}

STEPS=(
    "H" "He" "Hel" "Hell" "Hello"
    "Hello " "Hello W" "Hello Wo" "Hello Wor" "Hello Worl" "Hello World"
)

while true; do
    for _ in {1..2}; do
        show_frame "$BASE_DIR/helloworld/_.txt" 0.5
        show_frame "$BASE_DIR/artlist/temp.txt" 0.5
    done

    show_frame "$BASE_DIR/helloworld/_.txt" 0.2
    for s in "${STEPS[@]}"; do
        show_frame "$BASE_DIR/helloworld/${s}_.txt" 0.2
    done

    for _ in {1..5}; do
        show_frame "$BASE_DIR/helloworld/Hello World_.txt" 0.5
        show_frame "$BASE_DIR/helloworld/Hello World.txt" 0.5
    done

    for (( i=${#STEPS[@]}-1; i>=0; i-- )); do
        show_frame "$BASE_DIR/helloworld/${STEPS[$i]}_.txt" 0.15
    done
    show_frame "$BASE_DIR/helloworld/_.txt" 0.2
done
