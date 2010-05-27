/* Cosmetic settings */
static const char font[]         = "Inconsolata 12";
static const gboolean showlineno = True;
static const gboolean showtabs   = False;
static const gboolean hiline     = True;
static const gint     tw         = 4;
static const guint    margin     = 0; /* 0 for no margin */

/* Usability settings */
static const gboolean autoind    = True;
static const gboolean caseins    = True;
static const gboolean spaces     = False;

/* Local function declaration */
static void f_quit(const Arg *arg);

/* Args to spawn */
#define QUERY_TEXT(title,txt,p,pre,post)       { .v = (char *[]){ "/bin/sh", "-c", \
	"prop=\"`zenity --class Sandy --name sandy --title \"$0\" --entry --text \"$1\"`\" \
	&&" "xprop -id $5 -f $2 8s -set $2 \"$3$prop$4\"", \
	title, txt, p, pre, post, winid, NULL } }
#define QUERY_FILE(title,extra_opts,p,pre,post)       { .v = (char *[]){ "/bin/sh", "-c", \
	"prop=\"`zenity --class Sandy --name sandy --title \"$0\" --file-selection $1`\" \
	&&" "xprop -id $5 -f $2 8s -set $2 \"$3$prop$4\"", \
	title, extra_opts, p, pre, post, winid, NULL } }
#define FIND    QUERY_TEXT("Text search", "Find text:", "_SANDY_FIND", "", "")
#define TOLINE  QUERY_TEXT("Go to line", "Line number:", "_SANDY_LINE", "", "")
#define PIPE    QUERY_TEXT("Command filter", "Filter command:", "_SANDY_PIPEALL", "", "")
#define SED     QUERY_TEXT("Sed filter", "Sed command:",  "_SANDY_PIPELINES", "sed \'", "\'")
#define INSFILE QUERY_FILE("Insert file content", "", "_SANDY_PIPE", "cat \'", "\'")
#define OPENFILE { .v = (char *[]){ "/bin/sh", "-c", \
	"file=\"`zenity --class Sandy --name sandy --title Open_new_file --file-selection --save`\" &&" "$0 $file", progname, NULL } }

	/* This is  needed at sandy.c, do not delete */
#define SAVE_NO_FILE  QUERY_FILE("Save file as", "--save --confirm-overwrite", "_SANDY_SAVE", "", "")

/* Args to pipe_sel_* */
#define TOUPPER    { .v = (char *)"tr \'[:lower:]\' \'[:upper:]\'" }
#define TOLOWER    { .v = (char *)"tr \'[:upper:]\' \'[:lower:]\'" }
#define SWCASE     { .v = (char *)"tr \'[:upper:][:lower:]\' \'[:lower:][:upper:]\'" }
#define INDENTMORE { .v = (char *)"sed \'s/^/	/\'" }
#define INDENTLESS { .v = (char *)"sed \'s/^	//\'" }

/* Key bindings */
#define CTRLKEY GDK_CONTROL_MASK
#define METAKEY GDK_MOD1_MASK
#define CAPSKEY GDK_SHIFT_MASK

static Key keys[] = {
    /* modifier	         keyval    test           function     arg */
    { CTRLKEY,           GDK_c,    t_selection,   f_copy,      { 0 } },
    { CTRLKEY,           GDK_x,    t_sel_edit,    f_cut,       { 0 } },
    { CTRLKEY,           GDK_v,    t_editable,    f_paste,     { 0 } },
    { CTRLKEY,           GDK_f,    t_true,        f_spawn,     FIND },
    { 0,                 GDK_F3,   t_true,        f_find,      { .b = TRUE } },
    { CAPSKEY,           GDK_F3,   t_true,        f_find,      { .b = FALSE } },
    { CTRLKEY,           GDK_Tab,  t_editable,    f_pipelines, INDENTMORE },
    { CTRLKEY | CAPSKEY, GDK_Tab,  t_editable,    f_pipelines, INDENTLESS },
    { CTRLKEY,           GDK_u,    t_editable,    f_pipeall,   TOUPPER },
    { CTRLKEY,           GDK_l,    t_editable,    f_pipeall,   TOLOWER },
    { CTRLKEY,           GDK_g,    t_true,        f_spawn,     TOLINE },
    { CTRLKEY,           GDK_o,    t_true,        f_spawn,     OPENFILE },
    { CTRLKEY,           GDK_i,    t_editable,    f_spawn,     INSFILE },
    { CTRLKEY,           GDK_s,    t_true,        f_save,      { 0 } },
    { CTRLKEY,           GDK_p,    t_editable,    f_spawn,     PIPE },
    { CTRLKEY,           GDK_r,    t_editable,    f_spawn,     SED },
    { CTRLKEY,           GDK_w,    t_true,        f_quit,      { .b = FALSE } },
    { CTRLKEY,           GDK_q,    t_true,        f_quit,      { .b = TRUE } },
};

/* Actions */
static Item actions[] = {
    /* Disabled because standard GtkSourceView puts Undo/Redo in context menu */
    { "_Undo",            t_undo,      f_undo,       { 0 } },
    { "_Redo",            t_redo,      f_redo,       { 0 } },

    /* name              test         function     arg */
    { "_Go to Line...",   t_true,      f_spawn,     TOLINE },
    { "_Find...",         t_true,      f_spawn,     FIND },
    { "Find _Next",       t_selection, f_find,      { .b = TRUE } },
    { "Find _Prev",       t_selection, f_find,      { .b = FALSE } },
    { "Open_...",         t_true,      f_spawn,     OPENFILE },
    { "_Save/Save as...", t_modified,  f_save,      { 0 } },
    { "Pipe _text...",    t_editable,  f_spawn,     PIPE },
    { "Se_d text...",     t_editable,  f_spawn,     SED },
    { "_Insert File",     t_editable,  f_spawn,     INSFILE },
    { "Indent _More",     t_editable,  f_pipelines, INDENTMORE },
    { "Indent _Less",     t_editable,  f_pipelines, INDENTLESS },
    { "_UPPERCASE",       t_editable,  f_pipeall,   TOUPPER },
    { "l_owercase",       t_editable,  f_pipeall,   TOLOWER },
    { "s_WAP cASE",       t_editable,  f_pipeall,   SWCASE  },
    { "_Quit",            t_true,      f_quit,      { .b = FALSE } },
    { "Force quit (!!)",  t_true,      f_quit,      { .b = TRUE } },
};

/* Local function implementation */
void
f_quit(const Arg *arg) {
        if (arg->b) i_cleanup();
	else i_deleteevent();
}


