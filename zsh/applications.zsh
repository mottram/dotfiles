# Application-specific settings
# Set XDG base directories
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
# Use the right vim
if [[ $IS_OSX -eq 1 ]]; then
    export EDITOR=/usr/local/bin/nvim
elif [[ $IS_LINUX -eq 1 ]]; then
    export EDITOR=/usr/bin/nvim
fi
# Virtualenv
if [[ $IS_OSX -eq 1 ]]; then
    source /usr/local/bin/virtualenvwrapper.sh
fi
# RVM
if [[ $IS_OSX -eq 1 ]]; then
    PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
    [[ -s $HOME/.rvm/scripts/rvm ]] && source $HOME/.rvm/scripts/rvm
fi
# Pass
export PASSWORD_STORE_DIR=$HOME/Dropbox/Passwords
# Change cursor shape according to vi mode in iTerm 2
# | = insert mode
# ▌ = normal mode
if [[ $IS_OSX -eq 1 ]]; then
    function zle-keymap-select zle-line-init
    {
        case $KEYMAP in
            vicmd)      print -n -- "\E]50;CursorShape=0\C-G";;  # block cursor
            viins|main) print -n -- "\E]50;CursorShape=1\C-G";;  # line cursor
        esac
    
        zle reset-prompt
        zle -R
    }
    
    function zle-line-finish
    {
        print -n -- "\E]50;CursorShape=0\C-G"
    }
    
    zle -N zle-line-init
    zle -N zle-line-finish
    zle -N zle-keymap-select
fi
# Prettier gruvbox theme colours in iTerm2
if [[ $IS_OSX -eq 1 ]]; then
    source $HOME/.config/nvim/plugins/gruvbox/gruvbox_256palette_osx.sh
fi
# Disable homebrew analytics
if [[ $IS_OSX -eq 1 ]]; then
    export HOMEBREW_NO_ANALYTICS=1
fi
# Use deer on OS X
if [[ $IS_OSX -eq 1 ]]; then
    source $ZSH_PLUGINS_DIR/deer/deer.sh
    zle -N deer
    bindkey '\ek' deer
fi
