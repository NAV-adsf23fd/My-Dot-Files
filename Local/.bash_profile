#
# ~/.bash_profile
#

# Call .profile and .bashrc
[[ -f ~/.profile ]] && . ~/.profile
[[ -f ~/.bashrc ]] && . ~/.bashrc

# More optimal than just startx
if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
  exec startx
fi
