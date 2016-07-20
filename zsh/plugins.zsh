source $ZSH_PLUGINS_DIR/zsh-history-substring-search/zsh-history-substring-search.zsh
source $ZSH_PLUGINS_DIR/calc/calc.plugin.zsh
if [[ $IS_OSX -eq 1 ]]; then
    source $ZSH_PLUGINS_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh
    bindkey '^f' vi-forward-word
    bindkey '^g' autosuggest-clear
fi
source $ZSH_PLUGINS_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern root)
