autoload -U promptinit colors
promptinit
colors
setopt prompt_subst extended_glob longlistjobs nonomatch notify completeinword auto_cd auto_pushd pushdignoredups pushdminus pushdsilent pushdtohome

zsh_prompt_red="%{$fg_bold[red]%}"
zsh_prompt_green="%{$fg[green]%}"
zsh_prompt_reset_colour="%{$reset_color%}"
zsh_prompt_git_status() {
    if git rev-parse --git-dir > /dev/null 2>&1; then
        git diff --quiet || echo "·"
    fi
}
zsh_prompt_git_branch() {
    if git rev-parse --git-dir > /dev/null 2>&1; then
        git_branch=$(git symbolic-ref --short HEAD)
        echo " $git_branch"
    fi
}

PROMPT='%~$zsh_prompt_green$(zsh_prompt_git_branch)$zsh_prompt_reset_colour$zsh_prompt_red$(zsh_prompt_git_status)%(1j.%j.)$zsh_prompt_reset_colour %# '
