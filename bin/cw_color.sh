#!/bin/sh
# Make sure to change NICK to your correct nick and feel free to change the formatting to your liking
#

NICK="mottram"

reset="$(tput sgr0)"

bold="$(tput bold)"
dim="$(tput dim)"
under="$(tput smul)"
ununder="$(tput rmul)"
blink="$(tput blink)"
rev="$(tput rev)"
invis="$(tput invis)"

black="$(tput setaf 0)"
red="$(tput setaf 1)"
green="$(tput setaf 2)"
yellow="$(tput setaf 3)"
blue="$(tput setaf 4)"
magenta="$(tput setaf 5)"
cyan="$(tput setaf 6)"
white="$(tput setaf 7)"

bg_black="$(tput setab 0)"
bg_red="$(tput setab 1)"
bg_green="$(tput setab 2)"
bg_yellow="$(tput setab 3)"
bg_blue="$(tput setab 4)"
bg_magenta="$(tput setab 5)"
bg_cyan="$(tput setab 6)"
bg_white="$(tput setab 7)"

cw "$@" | sed -e "s/^\([-0-9]\{10,10\}\) \([:0-9]\{5,5\}\) <\([^ \t\r\n\v\f]*\)>/${yellow}\1 ${green}\2${reset} <${cyan}\3${reset}>/" \
              -e "s/^\([-0-9]\{10,10\}\) \([:0-9]\{5,5\}\) \(-!-\)/${yellow}\1 ${green}\2${reset} ${magenta}\3${reset}/" \
              -e "s/^\([-0-9]\{10,10\}\) \([:0-9]\{5,5\}\)/${yellow}\1 ${green}\2${reset}/" \
              -e "s/$NICK/\a${red}&${reset}/g" 
