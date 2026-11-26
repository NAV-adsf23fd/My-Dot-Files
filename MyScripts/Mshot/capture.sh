#!/bin/bash

TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
dir="$HOME/Media/Screenshot_${TIMESTAMP}.png"
temp="$HOME/Media/TempScreenShot/TempScreenshot_${TIMESTAMP}.png"

full_s() {
  mshot -f | tee $dir | xclip -selection clipboard -t image/png
}
window_s() {
  mshot -w | tee $dir | xclip -selection clipboard -t image/png
}
area_s() {
  mshot -a | tee $dir | xclip -selection clipboard -t image/png
}
full_c() {
  mshot -f | xclip -selection clipboard -t image/png
}
window_c() {
  mshot -w | xclip -selection clipboard -t image/png
}
area_c() {
  mshot -a | xclip -selection clipboard -t image/png
}
area_n_c() {
  mshot -a -s | tee $temp | xclip -selection clipboard -t image/png
}

case "$1" in
full_s | window_s | area_s | full_c | window_c | area_c | area_n_c)
  "$1" # call function
  ;;
*)
  echo "Invalid function"
  exit 1
  ;;
esac
