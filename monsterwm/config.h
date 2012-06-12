/* see LICENSE for copyright and license */

#ifndef CONFIG_H
#define CONFIG_H

/** buttons **/
#define MOD1            Mod1Mask    /* Alt key */
#define MOD4            Mod4Mask    /* Windows key */
#define CONTROL         ControlMask /* Control key */
#define SHIFT           ShiftMask   /* Shift key */

/** generic settings **/
#define MASTER_SIZE     0.52
#define SHOW_PANEL      False     /* show panel by default on exec */
#define TOP_PANEL       True      /* False mean panel is on bottom */
#define PANEL_HEIGHT    14        /* 0 for no space for panel, thus no panel */
#define DEFAULT_MODE    TILE      /* TILE MONOCLE BSTACK GRID */
#define ATTACH_ASIDE    True      /* False means new window is master */
#define FOLLOW_MOUSE    True      /* Focus the window the mouse just entered */
#define FOLLOW_WINDOW   False     /* Follow the window when moved to a different desktop */
#define CLICK_TO_FOCUS  True      /* Focus an unfocused window when clicked */
#define BORDER_WIDTH    1         /* window border width */
#define FOCUS           "#555555" /* focused window border color   */
#define UNFOCUS         "#444444" /* unfocused window border color */
#define DESKTOPS        4         /* number of desktops - edit DESKTOPCHANGE keys to suit */
#define DEFAULT_DESKTOP 0         /* the desktop to focus on exec */
#define MINWSZ          50        /* minimum window size in pixels */

/* open applications to specified desktop with specified mode.
 * if desktop is negative, then current is assumed */
static const AppRule rules[] = { \
    /*  class     desktop  follow  float */
    { "MPlayer",     3,    True,   False },
    { "Gimp",        0,    False,  True  },
};

/* helper for spawning shell commands */
#define SHCMD(cmd) {.com = (const char*[]){"/bin/sh", "-c", cmd, NULL}}

/** commands **/
static const char *termcmd[] = { "xterm",     NULL };
static const char *menucmd[] = { "dmenu_run", "-nb", "#002b36", "-nf", "#657b83", "-sb", "#002b36", "-sf", "#AAAAAA", NULL };
static const char *clipcmd[] = { "mydmenuclip", NULL };

#define DESKTOPCHANGE(K,N) \
    {  MOD4,             K,              change_desktop, {.i = N}}, \
    {  MOD4|ShiftMask,   K,              client_to_desktop, {.i = N}},

/** Shortcuts **/
static key keys[] = {
    /* modifier          key            function           argument */
    {  MOD4,             XK_b,          togglepanel,       {NULL}},
    {  MOD1,             XK_BackSpace,  focusurgent,       {NULL}},
    {  MOD4|SHIFT,       XK_c,          killclient,        {NULL}},
    {  MOD4,             XK_j,          next_win,          {NULL}},
    {  MOD4,             XK_k,          prev_win,          {NULL}},
    {  MOD4,             XK_h,          resize_master,     {.i = -10}}, /* decrease size in px */
    {  MOD4,             XK_l,          resize_master,     {.i = +10}}, /* increase size in px */
    {  MOD4,             XK_o,          resize_stack,      {.i = -10}}, /* shrink   size in px */
    {  MOD1,             XK_v,          resize_stack,      {.i = +10}}, /* grow     size in px */
    {  MOD1|CONTROL,     XK_h,          rotate,            {.i = -1}},
    {  MOD1|CONTROL,     XK_l,          rotate,            {.i = +1}},
    {  MOD1|SHIFT,       XK_h,          rotate_filled,     {.i = -1}},
    {  MOD1|SHIFT,       XK_l,          rotate_filled,     {.i = +1}},
    {  MOD1,             XK_Tab,        last_desktop,      {NULL}},
    {  MOD4,             XK_Return,     swap_master,       {NULL}},
    {  MOD4|SHIFT,       XK_j,          move_down,         {NULL}},
    {  MOD4|SHIFT,       XK_k,          move_up,           {NULL}},
    {  MOD4|SHIFT,       XK_t,          switch_mode,       {.i = TILE}},
    {  MOD4|SHIFT,       XK_m,          switch_mode,       {.i = MONOCLE}},
    {  MOD4|SHIFT,       XK_b,          switch_mode,       {.i = BSTACK}},
    {  MOD4|SHIFT,       XK_g,          switch_mode,       {.i = GRID}},
    {  MOD4|SHIFT,       XK_f,          switch_mode,       {.i = FLOAT}},
    {  MOD1|CONTROL,     XK_r,          quit,              {.i = 0}}, /* quit with exit value 0 */
    {  MOD1|CONTROL,     XK_q,          quit,              {.i = 1}}, /* quit with exit value 1 */
    {  MOD4|SHIFT,       XK_Return,     spawn,             {.com = termcmd}},
    {  MOD4,             XK_p,          spawn,             {.com = menucmd}},
    {  MOD4|SHIFT,       XK_v,          spawn,             {.com = clipcmd}},
    {  MOD4,             XK_Down,       moveresize,        {.v = (int []){   0,  25,   0,   0 }}}, /* move up    */
    {  MOD4,             XK_Up,         moveresize,        {.v = (int []){   0, -25,   0,   0 }}}, /* move down  */
    {  MOD4,             XK_Right,      moveresize,        {.v = (int []){  25,   0,   0,   0 }}}, /* move right */
    {  MOD4,             XK_Left,       moveresize,        {.v = (int []){ -25,   0,   0,   0 }}}, /* move left  */
    {  MOD4|SHIFT,       XK_Down,       moveresize,        {.v = (int []){   0,   0,   0,  25 }}}, /* height grow   */
    {  MOD4|SHIFT,       XK_Up,         moveresize,        {.v = (int []){   0,   0,   0, -25 }}}, /* height shrink */
    {  MOD4|SHIFT,       XK_Right,      moveresize,        {.v = (int []){   0,   0,  25,   0 }}}, /* width grow    */
    {  MOD4|SHIFT,       XK_Left,       moveresize,        {.v = (int []){   0,   0, -25,   0 }}}, /* width shrink  */
       DESKTOPCHANGE(    XK_1,                             0)
       DESKTOPCHANGE(    XK_2,                             1)
       DESKTOPCHANGE(    XK_3,                             2)
       DESKTOPCHANGE(    XK_4,                             3)
};

static Button buttons[] = {
    {  MOD1,    Button1,     mousemotion,   {.i = MOVE}},
    {  MOD1,    Button3,     mousemotion,   {.i = RESIZE}},
    {  MOD4,    Button3,     spawn,         {.com = menucmd}},
};
#endif
