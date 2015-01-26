alias c='clear'
alias x='exit'
alias g='git status'
alias h='history'
alias d='dirs -v'
alias ..='cd ..'
alias ...='cd .. ; cd ..'
if (( $IS_OSX ));then
    alias ls='ls -G'
fi
alias ll='ls -hl'
alias la='ls -ahl'
alias lt='ls -ahlt'
alias v='$EDITOR'
alias vi='$EDITOR'
alias sv='sudo $EDITOR'
alias p='ping -c 8 google.com'
alias myip="curl icanhazip.com"
alias ed='ed -p=" ~ "'
# Open various files in $EDITOR
alias -s md=$EDITOR
alias -s markdown=$EDITOR
alias -s txt=$EDITOR
alias -s css=$EDITOR
alias -s html=$EDITOR

if [[ $IS_OSX -eq 1 ]]; then
    alias td='/usr/local/bin/todo.sh -d ~/dotfiles/todo/mac-todo.cfg'
    alias te='v +sort ~/Dropbox/todo/todo.txt'
    alias fixopenwith='/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user'
    alias email="mbsync -q fastsync;mutt"
    alias nv="export VIMRUNTIME=/Applications/MacVim.app/Contents/Resources/vim/runtime;nvim"
fi

if [[ $HAS_PACMAN -eq 1 ]]; then
    # Turn off the display
    alias dispoff='sleep 1 && xset dpms force off' 
    # Suspend
    alias bye='sudo pm-suspend'
    # Wifi select
    alias wifiselect='sudo wifi-select wlan0'
    # Battery
    alias bat='acpi -b'
    # Mplayer without X
    alias fbplayer='mplayer -vo fbdev -screenw 1024 -screenh 600 -zoom -fs -xy 1024'
    # Stream Radio 4, 6 and the World Service with mplayer
    alias radio4='mplayer -cache 1024 -playlist http://www.bbc.co.uk/radio/listen/live/r4.asx'
    alias radio6='mplayer -playlist http://www.bbc.co.uk/radio/listen/live/r6.asx'
    alias radiows='mplayer -playlist http://www.bbc.co.uk/worldservice/meta/tx/nb/live_infent_au_nb.asx'
    # Todo.txt
    alias tt='~/dotfiles/todo/todo.sh -d ~/dotfiles/todo/eee-todo.cfg'
    # View PDF files
    alias pdf='zathura'
    # Play songs
    alias play='mplayer -playlist <(find "$PWD" -type f | sort -n)'
    # Virtualenvwrapper
    alias venv='export WORKON_HOME=~/envs;source /usr/bin/virtualenvwrapper.sh'
    # Search arch-wiki-docs
    alias aw='wiki-search-html'
fi 
