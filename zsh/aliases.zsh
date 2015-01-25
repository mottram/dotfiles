# Aliases for bash and zsh-------------------------------------------------

# General laziness---------------------------------------------------------
alias c='clear'
alias x='exit'
alias g='git status'
alias h='history'
alias ls='ls -G'
alias ..='cd ..'
alias ...='cd .. ; cd ..'
alias ll='ls -hl'
alias la='ls -ahl'
alias lt='ls -ahlt'
alias v='vim'
alias sv='sudo vim'
alias p='ping -c 8 google.com'
alias ed='ed --prompt="~ "'
alias d='dirs -v'

# Open various files in vim
alias -s md=vim
alias -s markdown=vim
alias -s txt=vim
alias -s css=vim
alias -s html=vim

# Package management crossplatformisation
# TODO: FreeBSD
if [[ $HAS_BREW -eq 1 ]]; then
    alias pkg_update='brew update'
    alias pkg_outdated='brew outdated'
    alias pkg_upgrade='brew upgrade'
    alias pkg_clean='brew cleanup'
    alias pkg_search='brew search'
    alias pkg_install='brew install'
elif [[ $HAS_PACMAN -eq 1 ]]; then
    alias pkg_update='pacman -Syy'
    alias pkg_outdated='pacman -Qu'
    alias pkg_upgrade='pacman -Syu'
    alias pkg_clean='paccache -r && paccache -ruk0'
    alias pkg_search='pacman -Ss'
    alias pkg_install='pacman -S'
elif [[ $HAS_APT -eq 1 ]]; then
    alias pkg_update='sudo apt-get update'
    alias pkg_outdated='sudo apt-get update && sudo apt-get -s upgrade'
    alias pkg_upgrade='sudo apt-get upgrade'
    alias pkg_clean='sudo apt-get clean'
    alias pkg_search='apt-cache search'
    alias pkg_install='sudo apt-get install'
fi

# Transmission-------------------------------------------------------------
# TODO: Work out why IP address is so much quicker than raspberrypi.local
alias transadd='transmission-remote 192.168.1.77:9091 -n $(cat ~/.transmission-pi) --add'
alias translist='transmission-remote 192.168.1.77:9091 -n $(cat ~/.transmission-pi) --list'
alias transdown='transmission-remote 192.168.1.77:9091 -n $(cat ~/.transmission-pi) --list | grep Down'
alias transup='transmission-remote 192.168.1.77:9091 -n $(cat ~/.transmission-pi) --list | grep Up'
alias transcli='transmission-remote-cli -c $(cat ~/.transmission-pi)@192.168.1.77:9091'

# Music--------------------------------------------------------------------
alias music="ncmpcpp -h 192.168.1.77"

# Specific to the MacBook--------------------------------------------------
# Lock screen
alias lock='/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend'
alias td='/usr/local/bin/todo.sh -d ~/dotfiles/todo/mac-todo.cfg'
alias te='v +sort ~/Dropbox/todo/todo.txt'
alias blog-deploy='cd ~/Weblog;rake integrate;rake gen_deploy'
alias macvim='v --servername=VIM --remote-tab'
alias fixopenwith='/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user'
alias email="mbsync -q fastsync;mutt"

# Specific to the Eee PC--------------------------------------------------
# Turn off the display
alias dispoff='sleep 1 && xset dpms force off' 
# Suspend
alias bye='sudo pm-suspend'
# Wifi select
alias wifiselect='sudo wifi-select wlan0'
# Battery
alias bat='acpi -b'
# Mount USB stick
alias mt16='sudo mount /dev/disk/by-label/16 /media/usb -o rw,users,async,noatime,umask=000'
# Mplayer without X
alias fbplayer='mplayer -vo fbdev -screenw 1024 -screenh 600 -zoom -fs -xy 1024'
# Stream Radio 4, 6 and the World Service with mplayer
alias radio4='mplayer -cache 1024 -playlist http://www.bbc.co.uk/radio/listen/live/r4.asx'
alias radio6='mplayer -playlist http://www.bbc.co.uk/radio/listen/live/r6.asx'
alias radiows='mplayer -playlist http://www.bbc.co.uk/worldservice/meta/tx/nb/live_infent_au_nb.asx'
# Todo.txt
alias tt='~/dotfiles/todo/todo.sh -d ~/dotfiles/todo/eee-todo.cfg'
# IP Address
alias myip="curl icanhazip.com"
# View PDF files
alias pdf='zathura'
# Play songs
alias play='mplayer -playlist <(find "$PWD" -type f | sort -n)'
# Pacman, pacaur & cower
alias ud='pacman -Qu && cower -u'
alias ug='pacaur -Syu'
# Virtualenvwrapper
alias venv='export WORKON_HOME=~/envs;source /usr/bin/virtualenvwrapper.sh'
# Search arch-wiki-docs
alias aw='wiki-search-html'


alias nv="export VIMRUNTIME=/Applications/MacVim.app/Contents/Resources/vim/runtime;nvim"
