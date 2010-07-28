if [ "$(whoami)" = "root" ]; then NCOLOR="red"; else NCOLOR="black"; fi

PROMPT='%{$fg[$NCOLOR]%}%B%n%b%{$reset_color%}:%{$fg[blue]%}%~%{$reset_color%} $(git_prompt_info)%(!.#.➜) '
RPROMPT='%{$fg[blue]%}[%*]%{$reset_color%}'

# git theming %B%c/%b%
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[black]%}(%{$fg_no_bold[black]%}%B"
ZSH_THEME_GIT_PROMPT_SUFFIX="%b%{$fg_bold[blue]%})%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_bold[red]%}✗"
