# Vi mode
bindkey -v
autoload -Uz edit-command-line
bindkey -M vicmd 'v' edit-command-line
bindkey -M vicmd '.' insert-last-word
export KEYTIMEOUT=1

# zsh-history-substring-search
zmodload zsh/terminfo
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

