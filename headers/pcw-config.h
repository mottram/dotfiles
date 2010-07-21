/*
 * This defines the command to run when you join a new channel or a new message comes in.
 * Use paths[wd] for the path to the channel's directory, channel for the channel name
 * (actually it's "name> " so it can be used as a prompt for srw), out for the out file
 * and in for the in fifo. If you want to do something more complicated, write a script to
 * put in your path and execute. For example, I replace cw with a script that calls cw but
 * pipes the output through sed for colors and bell on my nick so urxvt sets the urgent hint.
 */

/*
 * The default command
 */
#define CMD { "urxvt", "-title", paths[wd], "-e", "srw", "-p", channel, "cw", out, in, NULL }

/*
 * Use this if for some reason you really don't want to use srw, it's not necessary, but it makes
 * everything much nicer, there's a reason, it's the default...
 */
//#define CMD { "urxvt", "-title", paths[wd], "-e", "cw", out, in, NULL }


/*
 * Use this if you want colors and bell on your nick. You must first edit cw_color.sh to change the
 * nick, and then place it in your path. It is not installed by default.
 */
#define CMD { "urxvt", "-title", paths[wd], "-e", "srw", "-p", channel, "cw_color.sh", out, in, NULL }

/*
 * Use this if you want to use tabbed (http://tools.suckless.org/tabbed) so that each new channel is
 * it's own tab. Start tabbed with -d, then export the window id as pcw_window_id, then start pcw.
 * It would be fairly simple to do all three steps in a script, have fun! (and you can add the color
 * too if you want)
 */
//#define CMD { "urxvt", "-embed", getenv("pcw_window_id"), "-title", paths[wd], "-e", "srw", "-p", channel, "cw", out, in, NULL }
