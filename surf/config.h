/* modifier 0 means no modifier */
static char *useragent      = "Surf/"VERSION" (X11; U; Unix; en-US) AppleWebKit/531.2+ Compatible (Safari)";
static char *progress       = "#FF0000";
static char *progress_trust = "#00FF00";
static char *stylefile      = ".surf/style.css";
static char *scriptfile     = ".surf/script.js";
static char *cookiefile     = ".surf/cookies.txt";
static time_t sessiontime   = 3600;
#define NOBACKGROUND 0

#define SETPROP(p, q)     { .v = (char *[]){ "/bin/sh", "-c", \
	"prop=\"`xprop -id $2 $0 | cut -d '\"' -f 2 | dmenu`\" &&" \
	"xprop -id $2 -f $1 8s -set $1 \"$prop\"", \
	p, q, winid, NULL } }
#define DOWNLOAD(d) { \
	.v = (char *[]){ "/bin/sh", "-c", \
	"xterm -e \"wget --load-cookies ~/.surf/cookies.txt '$0';\"", \
	d, NULL } }
#define MODKEY GDK_CONTROL_MASK

#define BM_PICK { .v = (char *[]){ "/bin/sh", "-c", \
"xprop -id $0 -f _SURF_GO 8s -set _SURF_GO \
`cat ~/.surf/bookmarks | dmenu || exit 0`", \
winid, NULL } }

#define BM_ADD { .v = (char *[]){ "/bin/sh", "-c", \
"(echo `xprop -id $0 _SURF_URI | cut -d '\"' -f 2` && \
cat ~/.surf/bookmarks) | sort -u > ~/.surf/bookmarks_new && \
mv ~/.surf/bookmarks_new ~/.surf/bookmarks", \
winid, NULL } }

static Key keys[] = {
    /* modifier	            keyval      function    arg             Focus */
    { MODKEY|GDK_SHIFT_MASK,GDK_r,      reload,     { .b = TRUE } },
    { MODKEY,               GDK_r,      reload,     { .b = FALSE } },
    { MODKEY|GDK_SHIFT_MASK,GDK_p,      print,      { 0 } },
    { MODKEY,               GDK_p,      clipboard,  { .b = TRUE } },
    { MODKEY,               GDK_y,      clipboard,  { .b = FALSE } },
    { MODKEY|GDK_SHIFT_MASK,GDK_j,      zoom,       { .i = -1 } },
    { MODKEY|GDK_SHIFT_MASK,GDK_k,      zoom,       { .i = +1 } },
    { MODKEY|GDK_SHIFT_MASK,GDK_i,      zoom,       { .i = 0  } },
    { MODKEY,               GDK_l,      navigate,   { .i = +1 } },
    { MODKEY,               GDK_h,      navigate,   { .i = -1 } },
    { MODKEY,               GDK_j,      scroll,     { .i = +1 } },
    { MODKEY,               GDK_k,      scroll,     { .i = -1 } },
    { 0,                    GDK_Escape, stop,       { 0 } },
    { MODKEY,               GDK_o,      source,     { 0 } },
    { MODKEY,               GDK_g,      spawn,      SETPROP("_SURF_URI", "_SURF_GO") },
    { MODKEY,               GDK_slash,  spawn,      SETPROP("_SURF_FIND", "_SURF_FIND") },
    { MODKEY,               GDK_n,      find,       { .b = TRUE } },
    { MODKEY|GDK_SHIFT_MASK,GDK_n,      find,       { .b = FALSE } },
    { MODKEY,               GDK_b,      spawn,      BM_PICK },
    { MODKEY|GDK_SHIFT_MASK,GDK_b,      spawn,      BM_ADD },
    { MODKEY,   GDK_i,  spawn,  { .v = (char *[]){ "/bin/sh", "-c", "curl -s -d username=\"$(cat ~/.surf/instapaper | sed -n '1p')\" -d password=\"$(cat ~/.surf/instapaper | sed -n '2p')\" -d url=\"$(xprop -id $0 _SURF_URI | cut -d '\"' -f 2)\" https://www.instapaper.com/api/add > /dev/null", winid, NULL } } },
};
