# Only run in interactive shell
case $- in
    *i*) ;;
      *) return;;
esac

# History
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s histappend
shopt -s checkwinsize

# Colors + aliases
if command -v dircolors >/dev/null; then
    eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
fi

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias op="~/Applications/Config/MyScripts/OpenFile/openfile.sh"
alias config="cd ~/Applications/Config"
alias linhtinh="cd ~/Downloads/linhtinh"

# PATH
# export PATH="$HOME/Applications/Linux/Miniconda/bin:$PATH"  # commented out by conda initialize

# Starship
eval "$(starship init bash)"



[ -f "$CARGO_HOME/env" ] && . "$CARGO_HOME/env"


# stow config
alias restow='stow --no-folding -R -d "$HOME/Applications/Config" -t "$HOME" Local'
alias restow-sys='sudo stow --no-folding -R -d "$HOME/Applications/Config" -t / System'

