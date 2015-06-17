source $ZSH_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
source $ZSH_DIR/zsh-history-substring-search/zsh-history-substring-search.zsh
source $ZSH_DIR/opp/opp.zsh
source $ZSH_DIR/opp/opp/*.zsh
source $ZSH_DIR/zsh-autosuggestions/autosuggestions.zsh
zle-line-init() {
        zle autosuggest-start
    }
zle -N zle-line-init
bindkey '^f' vi-forward-blank-word
