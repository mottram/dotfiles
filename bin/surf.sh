#!/bin/sh
# $1 = $xid
# $2 = $p = _SURF_FIND _SURF_BMARK _SURF_URI _SURF_URI_RAW (what SETPROP sets in config.h)
#
# // replace default setprop with this one
# #define SETPROP(p) { .v = (char *[]){ "/bin/sh", "-c", "surf.sh $0 $1", winid, p, NULL } }
#
# // fix shift+slash keybinding in spanish keyboard (f.example)
# { MODKEY,               GDK_g,      spawn,      SETPROP("_SURF_URI") },
# { MODKEY|GDK_SHIFT_MASK,GDK_g,      spawn,      SETPROP("_SURF_URI_RAW") },
# { MODKEY,               GDK_f,      spawn,      SETPROP("_SURF_FIND") },
# { MODKEY,               GDK_b,      spawn,      SETPROP("_SURF_BMARK") },

font='-*-terminus-medium-*-*-*-*-*-*-*-*-*-*-*'
normbgcolor='#181818'
normfgcolor='#e9e9e9'
selbgcolor='#dd6003'
selfgcolor='#e9e9e9'
bmarks=~/.surf/bookmarks.txt

xid=$1
p=$2
uri=`xprop -id $xid _SURF_URI | cut -d '"' -f 2`
kw=`xprop -id $xid _SURF_FIND | cut -d '"' -f 2`
dmenu="dmenu -e $xid -fn $font -nb $normbgcolor -nf $normfgcolor \
       -sb $selbgcolor -sf $selfgcolor"

s_xprop() {
    [ -n "$2" ] && xprop -id $xid -f $1 8s -set $1 "$2"
}

case "$p" in
"_SURF_FIND")
    ret="`echo $kw | $dmenu -p find:`"
    s_xprop _SURF_FIND "$ret"
    ;;
"_SURF_BMARK")
    grep "$uri" $bmarks >/dev/null 2>&1 || echo "$uri" >> $bmarks
    ;;
"_SURF_URI_RAW")
    ret=`echo $uri | $dmenu -p "uri:"`
    s_xprop _SURF_GO "$ret"
    ;;
"_SURF_URI")
    sel=`tac $bmarks 2> /dev/null | $dmenu -p "uri [dgtwy*]:"`
    [ -z "$sel" ] && exit
    opt=$(echo $sel | cut -d ' ' -f 1)
    arg=$(echo $sel | cut -d ' ' -f 2-)
    case "$opt" in
    "d") # del.icio.us
        ret="http://del.icio.us/save?url=$uri"
        ;;
    "g") # google for it
        ret="http://www.google.com/search?q=$arg"
        ;;
    "t") # tinyurl
        ret="http://tinyurl.com/create.php?url=$uri"
        ;;
    "w") # wikipedia
        ret="http://wikipedia.org/wiki/$arg"
        ;;
    "y") # youtube
        ret="http://www.youtube.com/results?search_query=$arg&aq=f"
        ;;
    *)
        ret="$sel"
        ;;
    esac
    s_xprop _SURF_GO "$ret"
    ;;
*)
    echo Unknown xprop
    ;;
esac