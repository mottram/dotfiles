# Check for operating system
if [[ $(uname) = 'Linux' ]]; then
    IS_LINUX=1
fi

if [[ $(uname) = 'Darwin' ]]; then
    IS_OSX=1
fi

if [[ $(uname) = 'FreeBSD' ]]; then
    IS_FREEBSD=1
fi

# Check for software
if (( $+commands[brew] )); then
    HAS_BREW=1
fi

if (( $+commands[apt-get] )); then
    HAS_APT=1
fi

if (( $+commands[pacman] )); then
    HAS_PACMAN=1
fi

# Check for GNU coreutils on OS X
if [[ $IS_OSX -eq 1 && -x /usr/local/bin/gls ]]; then
    HAS_GNU_COREUTILS=1
fi

# Check to see if we're inside Neovim
if [ "$NVIM_LISTEN_ADDRESS" != "" ]; then
    IS_NVIM=1
fi
