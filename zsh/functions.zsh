# quick git commit
function gg {
  git commit -v -a -m "$*"
}

# view source files with pygments syntax colouring
function pless {
  pygmentize $1 | less -rN
}

# mkdir, cd into it
function mkcd {
mkdir -p "$*"
cd "$*"
}

# list and ack
function lgr {
  ls -a | ack -i $1 
}

# Poor man's Notational Velocity
function note {
  vim ~/notes/"$*".txt	
}

function nls {
  ls -c ~/notes | ack "$*"
}

# make a backup of a file
function bk {
    cp -a "$1" "${1}_$(date -u)"
}

# Find files since $1 days
function fr {
    find ./* -mtime -$1 | cut -c3-
}

function cdf {
    target=`osascript -e 'tell application "Finder" to if (count of Finder windows) > 0 then get POSIX path of (target of front Finder window as text)'`
    if [ "$target" != "" ]; then
        cd "$target"; pwd
    else
        echo 'No Finder window found' >&2
    fi
}

# Tumblr

# tumqueue() {
# tumblr post --queue "$1" --host=onethingwell.org 2>/dev/null
# open https://www.tumblr.com/blog/onethingwell/queue
# }

# tumdraft() {
# tumblr post --draft "$1" --host=onethingwell.org 2>/dev/null
# open https://www.tumblr.com/blog/onethingwell/drafts
# }

# grep for running processes

function any {
    if [[ -z "$1" ]] ; then
        echo "any - grep for process(es) by keyword" >&2
        echo "Usage: any <keyword>" >&2 ; return 1
    else
        ps xauwww | grep -i "$1" | grep -v "grep"
    fi
}


# Add contents of a file to the OS X clipboard

function clip {
    type=`file "$1"|grep -c text`
    if [ $type -gt 0 ]; then
        cat "$@"|pbcopy
        echo "Contents of $1 are in the clipboard."
    else
        echo "File \"$1\" is not plain text."
    fi
}

# Notify when finished/failed

function nwf {
    "$@"
    if [ $? -gt 0 ]; then
        notify-send -u critical "$1 FAILED"
    else
        notify-send -u critical "$1 finished"
    fi
}

# mpc search 'n' play

function mpcplay {
    type=$(echo "$1" | sed 's/\<./\u&/')
    term=$(echo "$2" | sed 's/\<./\u&/')
    if pidof -x mpd >/dev/null
        then
            mpc -q pause
            mpc -q clear
            mpc search "$1" "$2" | mpc add
            mpc -q shuffle
            mpc -q play
            echo ":: $type '$term' now playing."
    else
        echo ":: MPD isn't running"
    fi
}

# Coloured man pages
function man {
  env \
LESS_TERMCAP_mb=$(printf "\e[1;31m") \
LESS_TERMCAP_md=$(printf "\e[1;31m") \
LESS_TERMCAP_me=$(printf "\e[0m") \
LESS_TERMCAP_se=$(printf "\e[0m") \
LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
LESS_TERMCAP_ue=$(printf "\e[0m") \
LESS_TERMCAP_us=$(printf "\e[1;32m") \
    man "$@"
}

# Improved xclip from 
# http://madebynathan.com/2011/10/04/a-nicer-way-to-use-xclip/

function cb {
  local _scs_col="\e[0;32m"; local _wrn_col='\e[1;31m'; local _trn_col='\e[0;33m'
  # Check that xclip is installed.
  if ! type xclip > /dev/null 2>&1; then
    echo -e "$_wrn_col""You must have the 'xclip' program installed.\e[0m"
  # Check user is not root (root doesn't have access to user xorg server)
  elif [ "$USER" == "root" ]; then
    echo -e "$_wrn_col""Must be regular user (not root) to copy a file to the clipboard.\e[0m"
  else
    # If no tty, data should be available on stdin
    if [ "$( tty )" == 'not a tty' ]; then
      input="$(< /dev/stdin)"
    # Else, fetch input from params
    else
      input="$*"
    fi
    if [ -z "$input" ]; then  # If no input, print usage message.
      echo "Copies a string or the contents of a file to the clipboard."
      echo "Usage: cb <string or file>"
      echo "       echo <string or file> | cb"
    else
      # If the input is a filename that exists, then use the contents of that file.
      if [ -e "$input" ]; then input="$(cat $input)"; fi
      # Copy input to clipboard
      echo -n "$input" | xclip -selection c
      # Truncate text for status
      if [ ${#input} -gt 80 ]; then input="$(echo $input | cut -c1-80)$_trn_col...\e[0m"; fi
      # Print status.
      echo -e "$_scs_col""Copied to clipboard:\e[0m $input"
    fi
  fi
}
