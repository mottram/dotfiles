# Command history
HISTCONTROL=erasedups
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt  append_history share_history hist_verify extended_history histignorespace hist_ignore_all_dups
export HISTIGNORE="&:ls:ll:la:l.:pwd:exit:clear:clr:c:x:[bf]g"

# Directory history
DIRSTACKSIZE=${DIRSTACKSIZE:-20}
DIRSTACKFILE=${DIRSTACKFILE:-${ZDOTDIR:-${HOME}}/.zsh_directory_history}

if [[ -f ${DIRSTACKFILE} ]] && [[ ${#dirstack[*]} -eq 0 ]] ; then
    dirstack=( ${(f)"$(< $DIRSTACKFILE)"} )
    [[ -d $dirstack[1] ]] && cd $dirstack[1] && cd $OLDPWD
fi

chpwd() {
    if (( $DIRSTACKSIZE <= 0 )) || [[ -z $DIRSTACKFILE ]]; then return; fi
    local -ax my_stack
    my_stack=( ${PWD} ${dirstack} )
    builtin print -l ${(u)my_stack} >! ${DIRSTACKFILE}
}
