/* modifier 0 means no modifier */
static char *useragent      = "Mozilla/5.0 (X11; U; Linux; en-us) AppleWebKit/531.2+ (KHTML, like Gecko, surf-"VERSION") Safari/531.2+";
static char *progress       = "#FF0000";
static char *progress_trust = "#00FF00";
static char *stylefile      = ".surf/style.css";
static char *scriptfile     = ".surf/script.js";
static char *cookiefile     = ".surf/cookies.txt";
static char *dldir          = ".surf/dl/";
static time_t sessiontime   = 3600;

#define SETPROP(p)       { .v = (char *[]){ "/bin/sh", "-c", \
	"prop=\"`xprop -id $1 $0 | cut -d '\"' -f 2 | dmenu`\" &&" \
	"xprop -id $1 -f $0 8s -set $0 \"$prop\"", \
	p, winid, NULL } }
#define MODKEY GDK_CONTROL_MASK
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
    { MODKEY,               GDK_g,      spawn,      SETPROP("_SURF_URI") },
    { MODKEY,               GDK_slash,  spawn,      SETPROP("_SURF_FIND") },
    { MODKEY,               GDK_n,      find,       { .b = TRUE } },
    { MODKEY|GDK_SHIFT_MASK,GDK_n,      find,       { .b = FALSE } },
};

static Item items[] = {
    { "Back",           navigate,  { .i = -1 } },
    { "Forward",        navigate,  { .i = +1 } },
    { "New Window",     newwindow, { .v = NULL } },
    { "Reload",         reload,    { .b = FALSE } },
    { "Stop",           stop,      { 0 } },
    { "Paste URI",      clipboard, { .b = TRUE } },
    { "Copy URI",       clipboard, { .b = FALSE } },
    { "Download",       download,  { 0 } },
};
