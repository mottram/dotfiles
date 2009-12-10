#! /bin/bash

# NOTE:  Todo.sh requires the todo.cfg configuration file to run.
# Place the todo.cfg file in your home directory or use the -d option for a custom location.

version() { sed -e 's/^    //' <<EndVersion
        TODO.TXT Manager
        Version 2.1
        Author:  Gina Trapani (ginatrapani@gmail.com)
        Last updated:  2/23/2009
        Release date:  5/11/2006
        License:  GPL, http://www.gnu.org/copyleft/gpl.html
        More information and mailing list at http://todotxt.com
EndVersion
    exit 1
}

usage()
{
    sed -e 's/^    //' <<EndUsage
    Usage: todo.sh  [-fhpantvV] [-d todo_config] action [task_number] [task_description]
    Try 'todo.sh -h' for more information.
EndUsage
    exit 1
}


help()
{
    sed -e 's/^    //' <<EndHelp
      Usage:  todo.sh [-fhpantvV] [-d todo_config] action [task_number] [task_description]

      Actions:
        add "THING I NEED TO DO +project @context"
        a "THING I NEED TO DO +project @context"
          Adds THING I NEED TO DO to your todo.txt file on its own line.
          Project and context notation optional.
          Quotes optional.

        addto DEST "TEXT TO ADD"
          Adds a line of text to any file located in the todo.txt directory.
          For example, addto inbox.txt "decide about vacation"

        append NUMBER "TEXT TO APPEND"
        app NUMBER "TEXT TO APPEND"
          Adds TEXT TO APPEND to the end of the todo on line NUMBER.
          Quotes optional.

        archive
          Moves done items from todo.txt to done.txt and removes blank lines.

        command [ACTIONS]
          Runs the remaining arguments using only todo.sh builtins.
          Will not call any .todo.actions.d scripts.

        del NUMBER [TERM]
        rm NUMBER [TERM]
          Deletes the item on line NUMBER in todo.txt.
          If term specified, deletes only the term from the line.

        depri NUMBER
        dp NUMBER
          Deprioritizes (removes the priority) from the item
          on line NUMBER in todo.txt.

        do NUMBER
          Marks item on line NUMBER as done in todo.txt.

        list [TERM...]
        ls [TERM...]
          Displays all todo's that contain TERM(s) sorted by priority with line
          numbers.  If no TERM specified, lists entire todo.txt.

        listall [TERM...]
        lsa [TERM...]
          Displays all the lines in todo.txt AND done.txt that contain TERM(s)
          sorted by priority with line  numbers.  If no TERM specified, lists
          entire todo.txt AND done.txt concatenated and sorted.

        listcon
        lsc
          Lists all the task contexts that start with the @ sign in todo.txt.

        listfile SRC [TERM...]
        lf SRC [TERM...]
          Displays all the lines in SRC file located in the todo.txt directory,
          sorted by priority with line  numbers.  If TERM specified, lists
          all lines that contain TERM in SRC file.

        listpri [PRIORITY]
        lsp [PRIORITY]
          Displays all items prioritized PRIORITY.
          If no PRIORITY specified, lists all prioritized items.

        listproj
        lsprj
          Lists all the projects that start with the + sign in todo.txt.

        move NUMBER DEST [SRC]
        mv NUMBER DEST [SRC]
          Moves a line from source text file (SRC) to destination text file (DEST).
          Both source and destination file must be located in the directory defined
          in the configuration directory.  When SRC is not defined
          it's by default todo.txt.

        prepend NUMBER "TEXT TO PREPEND"
        prep NUMBER "TEXT TO PREPEND"
          Adds TEXT TO PREPEND to the beginning of the todo on line NUMBER.
          Quotes optional.

        pri NUMBER PRIORITY
        p NUMBER PRIORITY
          Adds PRIORITY to todo on line NUMBER.  If the item is already
          prioritized, replaces current priority with new PRIORITY.
          PRIORITY must be an uppercase letter between A and Z.

        replace NUMBER "UPDATED TODO"
          Replaces todo on line NUMBER with UPDATED TODO.

        report
          Adds the number of open todo's and closed done's to report.txt.



      Options:
        -@
            Hide context names in list output. Use twice to show context
            names (default).
        -+
            Hide project names in list output. Use twice to show project
            names (default).
        -d CONFIG_FILE
            Use a configuration file other than the default ~/todo.cfg
        -f
            Forces actions without confirmation or interactive input
        -h
            Display this help message
        -p
            Plain mode turns off colors
        -P
            Hide priority labels in list output. Use twice to show
            priority labels (default).
        -a
            Don't auto-archive tasks automatically on completion
        -n
            Don't preserve line numbers; automatically remove blank lines
            on task deletion
        -t
            Prepend the current date to a task automatically
            when it's added.
        -v
            Verbose mode turns on confirmation messages
        -V
            Displays version, license and credits


      Environment variables:
        TODOTXT_AUTO_ARCHIVE=0          is same as option -a
        TODOTXT_CFG_FILE=CONFIG_FILE    is same as option -d CONFIG_FILE
        TODOTXT_FORCE=1                 is same as option -f
        TODOTXT_PRESERVE_LINE_NUMBERS=0 is same as option -n
        TODOTXT_PLAIN=1                 is same as option -p
        TODOTXT_DATE_ON_ADD=1           is same as option -t
        TODOTXT_VERBOSE=1               is same as option -v
EndHelp

    if [ -d "$HOME/.todo.actions.d" ]
    then
        echo ""
        for action in $HOME/.todo.actions.d/*
        do
            if [ -x $action ]
            then
                $action usage
            fi
        done
        echo ""
    fi


    exit 1
}

die()
{
    echo "$*"
    exit 1
}

cleanup()
{
    [ -f "$TMP_FILE" ] && rm "$TMP_FILE"
    exit 0
}

archive()
{
    #defragment blank lines
    sed -i.bak -e '/./!d' "$TODO_FILE"
    [[ $TODOTXT_VERBOSE = 1 ]] && grep "^x " "$TODO_FILE"
    grep "^x " "$TODO_FILE" >> "$DONE_FILE"
    sed -i.bak '/^x /d' "$TODO_FILE"
    cp "$TODO_FILE" "$TMP_FILE"
    sed -n 'G; s/\n/&&/; /^\([ -~]*\n\).*\n\1/d; s/\n//; h; P' "$TMP_FILE" > "$TODO_FILE"
    #[[ $TODOTXT_VERBOSE = 1 ]] && echo "TODO: Duplicate tasks have been removed."
    [[ $TODOTXT_VERBOSE = 1 ]] && echo "TODO:  $TODO_FILE archived."
    cleanup
}


# == PROCESS OPTIONS ==
while getopts ":fhpnatvV+@Pd:" Option
do
  case $Option in
    '@' )
        ## HIDE_CONTEXT_NAMES starts at zero (false); increment it to one
        ##   (true) the first time this flag is seen. Each time the flag
        ##   is seen after that, increment it again so that an even
        ##   number hides project names and an odd number shows project
        ##   names.
        : $(( HIDE_CONTEXT_NAMES++ ))
        if [ $(( $HIDE_CONTEXT_NAMES % 2 )) -eq 0 ]
        then
            ## Zero or even value -- show context names
            unset HIDE_CONTEXTS_SUBSTITUTION
        else
            ## One or odd value -- hide context names
            HIDE_CONTEXTS_SUBSTITUTION='[[:space:]]@[^[:space:]]\{1,\}'
        fi
        ;;
    '+' )
        ## HIDE_PROJECT_NAMES starts at zero (false); increment it to one
        ##   (true) the first time this flag is seen. Each time the flag
        ##   is seen after that, increment it again so that an even
        ##   number hides project names and an odd number shows project
        ##   names.
        : $(( HIDE_PROJECT_NAMES++ ))
        if [ $(( $HIDE_PROJECT_NAMES % 2 )) -eq 0 ]
        then
            ## Zero or even value -- show project names
            unset HIDE_PROJECTS_SUBSTITUTION
        else
            ## One or odd value -- hide project names
            HIDE_PROJECTS_SUBSTITUTION='[[:space:]][+][^[:space:]]\{1,\}'
        fi
        ;;
    a )
        TODOTXT_AUTO_ARCHIVE=0
        ;;
    d )
        TODOTXT_CFG_FILE=$OPTARG
        ;;
    f )
        TODOTXT_FORCE=1
        ;;
    h )
        help
        ;;
    n )
        TODOTXT_PRESERVE_LINE_NUMBERS=0
        ;;
    p )
        TODOTXT_PLAIN=1
        ;;
    P )
        ## HIDE_PRIORITY_LABELS starts at zero (false); increment it to one
        ##   (true) the first time this flag is seen. Each time the flag
        ##   is seen after that, increment it again so that an even
        ##   number hides project names and an odd number shows project
        ##   names.
        : $(( HIDE_PRIORITY_LABELS++ ))
        if [ $(( $HIDE_PRIORITY_LABELS % 2 )) -eq 0 ]
        then
            ## Zero or even value -- show priority labels
            unset HIDE_PRIORITY_SUBSTITUTION
        else
            ## One or odd value -- hide priority labels
            HIDE_PRIORITY_SUBSTITUTION="([A-Z])[[:space:]]"
        fi
        ;;
    t )
        TODOTXT_DATE_ON_ADD=1
        ;;
    v )
        TODOTXT_VERBOSE=1
        ;;
    V )
        version
        ;;
  esac
done
shift $(($OPTIND - 1))

# defaults if not yet defined
TODOTXT_VERBOSE=${TODOTXT_VERBOSE:-1}
TODOTXT_PLAIN=${TODOTXT_PLAIN:-0}
TODOTXT_CFG_FILE=${TODOTXT_CFG_FILE:-$HOME/todo.cfg}
TODOTXT_FORCE=${TODOTXT_FORCE:-0}
TODOTXT_PRESERVE_LINE_NUMBERS=${TODOTXT_PRESERVE_LINE_NUMBERS:-1}
TODOTXT_AUTO_ARCHIVE=${TODOTXT_AUTO_ARCHIVE:-1}
TODOTXT_DATE_ON_ADD=${TODOTXT_DATE_ON_ADD:-0}

[ -e "$TODOTXT_CFG_FILE" ] || {
    CFG_FILE_ALT="$HOME/.todo.cfg"

    if [ -e "$CFG_FILE_ALT" ]
    then
        TODOTXT_CFG_FILE="$CFG_FILE_ALT"
    fi
}

export TODOTXT_VERBOSE TODOTXT_PLAIN TODOTXT_CFG_FILE TODOTXT_FORCE TODOTXT_PRESERVE_LINE_NUMBERS TODOTXT_AUTO_ARCHIVE TODOTXT_DATE_ON_ADD

TODO_SH="$0"
export TODO_SH

# === SANITY CHECKS (thanks Karl!) ===
[ -r "$TODOTXT_CFG_FILE" ] || die "Fatal error:  Cannot read configuration file $TODOTXT_CFG_FILE"

. "$TODOTXT_CFG_FILE"

[ -z "$1" ]         && usage
[ -d "$TODO_DIR" ]  || die "Fatal Error: $TODO_DIR is not a directory"
cd "$TODO_DIR"      || die "Fatal Error: Unable to cd to $TODO_DIR"

echo '' > "$TMP_FILE" || die "Fatal Error:  Unable to write in $TODO_DIR"
[ -f "$TODO_FILE" ] || cp /dev/null "$TODO_FILE"
[ -f "$DONE_FILE" ] || cp /dev/null "$DONE_FILE"
[ -f "$REPORT_FILE" ] || cp /dev/null "$REPORT_FILE"

if [ $TODOTXT_PLAIN = 1 ]; then
    PRI_A=$NONE
    PRI_B=$NONE
    PRI_C=$NONE
    PRI_X=$NONE
    DEFAULT=$NONE
fi

# === HEAVY LIFTING ===
shopt -s extglob

# == HANDLE ACTION ==
action=$( printf "%s\n" "$1" | tr 'A-Z' 'a-z' )

## If the first argument is "command", run the rest of the arguments
## using todo.sh builtins.
## Else, run a actions script with the name of the command if it exists
## or fallback to using a builtin
if [ "$action" == command ]
then
    ## Get rid of "command" from arguments list
    shift
    ## Reset action to new first argument
    action=$( printf "%s\n" "$1" | tr 'A-Z' 'a-z' )
elif [ -d "$HOME/.todo.actions.d" -a -x "$HOME/.todo.actions.d/$action" ]
then
    "$HOME/.todo.actions.d/$action" "$@"
    cleanup
fi

## Only run if $action isn't found in .todo.actions.d
case $action in
"add" | "a")
    if [[ -z "$2" && $TODOTXT_FORCE = 0 ]]; then
        echo -n "Add: "
        read input
    else
        [ -z "$2" ] && die "usage: $0 add \"TODO ITEM\""
        shift
        input=$*
    fi

    if [[ $TODOTXT_DATE_ON_ADD = 1 ]]; then
        now=`date '+%Y-%m-%d'`
        input="$now $input"
    fi
    echo "$input" >> "$TODO_FILE"
    TASKNUM=$(wc -l "$TODO_FILE" | sed 's/^[[:space:]]*\([0-9]*\).*/\1/')
    [[ $TODOTXT_VERBOSE = 1 ]] && echo "TODO: '$input' added on line $TASKNUM."
    cleanup;;

"addto" )
    [ -z "$2" ] && die "usage: $0 addto DEST \"TODO ITEM\""
    dest="$TODO_DIR/$2"
    [ -z "$3" ] && die "usage: $0 addto DEST \"TODO ITEM\""
    shift
    shift
    input=$*

    if [ -f "$dest" ]; then
        echo "$input" >> "$dest"
        TASKNUM=$(wc -l "$dest" | sed 's/^[[:space:]]*\([0-9]*\).*/\1/')
        [[ $TODOTXT_VERBOSE = 1 ]] && echo "TODO: '$input' added to $dest on line $TASKNUM."
    else
        echo "TODO:  Destination file $dest does not exist."
    fi
    cleanup;;

"append" | "app" )
    errmsg="usage: $0 append ITEM# \"TEXT TO APPEND\""
    shift; item=$1; shift

    [ -z "$item" ] && die "$errmsg"
    [[ "$item" = +([0-9]) ]] || die "$errmsg"
    todo=$(sed "$item!d" "$TODO_FILE")
    [ -z "$todo" ] && die "$item:  No such todo."
    if [[ -z "$1" && $TODOTXT_FORCE = 0 ]]; then
        echo -n "Append: "
        read input
    else
        input=$*
    fi
    if sed -i.bak $item" s|^.*|& $input|" "$TODO_FILE"; then
        newtodo=$(sed "$item!d" "$TODO_FILE")
        [[ $TODOTXT_VERBOSE = 1 ]] && echo "$item: $newtodo"
    else
        echo "TODO:  Error appending task $item."
    fi
    cleanup;;

"archive" )
    archive;;

"del" | "rm" )
    # replace deleted line with a blank line when TODOTXT_PRESERVE_LINE_NUMBERS is 1
    errmsg="usage: $0 del ITEM#"
    item=$2
    [ -z "$item" ] && die "$errmsg"

    if [ -z "$3" ]; then

        [[ "$item" = +([0-9]) ]] || die "$errmsg"
        if sed -ne "$item p" "$TODO_FILE" | grep "^."; then
            DELETEME=$(sed "$2!d" "$TODO_FILE")

            if  [ $TODOTXT_FORCE = 0 ]; then
                echo "Delete '$DELETEME'?  (y/n)"
                read ANSWER
            else
                ANSWER="y"
            fi
            if [ "$ANSWER" = "y" ]; then
                if [ $TODOTXT_PRESERVE_LINE_NUMBERS = 0 ]; then
                    # delete line (changes line numbers)
                    sed -i.bak -e $2"s/^.*//" -e '/./!d' "$TODO_FILE"
                else
                    # leave blank line behind (preserves line numbers)
                    sed -i.bak -e $2"s/^.*//" "$TODO_FILE"
                fi
                [[ $TODOTXT_VERBOSE = 1 ]] && echo "TODO:  '$DELETEME' deleted."
                cleanup
            else
                echo "TODO:  No tasks were deleted."
            fi
        else
            echo "$item: No such todo."
        fi
    else
        sed -i.bak -e $item"s/$3/ /g"  "$TODO_FILE"
        [[ $TODOTXT_VERBOSE = 1 ]] && echo "TODO:  $3 removed from $item."
    fi ;;

"depri" | "dp" )
    item=$2
    errmsg="usage: $0 depri ITEM#"

    todo=$(sed "$item!d" "$TODO_FILE")
    [ -z "$todo" ] && die "$item:  No such todo."
    [[ "$item" = +([0-9]) ]] || die "$errmsg"

    sed -e $item"s/^(.*) //" "$TODO_FILE" > /dev/null 2>&1

    if [ "$?" -eq 0 ]; then
        #it's all good, continue
        sed -i.bak -e $2"s/^(.*) //" "$TODO_FILE"
        NEWTODO=$(sed "$2!d" "$TODO_FILE")
        [[ $TODOTXT_VERBOSE = 1 ]] && echo -e "`echo "$item: $NEWTODO"`"
        [[ $TODOTXT_VERBOSE = 1 ]] && echo "TODO: $item deprioritized."
        cleanup
    else
        die "$errmsg"
    fi;;

"do" )
    errmsg="usage: $0 do ITEM#"
    item=$2
    [ -z "$item" ] && die "$errmsg"
    [[ "$item" = +([0-9]) ]] || die "$errmsg"

    todo=$(sed "$item!d" "$TODO_FILE")
    [ -z "$todo" ] && die "$item:  No such todo."

    now=`date '+%Y-%m-%d'`
    # remove priority once item is done
    sed -i.bak $item"s/^(.*) //" "$TODO_FILE"
    sed -i.bak $item"s|^|&x $now |" "$TODO_FILE"
    newtodo=$(sed "$item!d" "$TODO_FILE")
    [[ $TODOTXT_VERBOSE = 1 ]] && echo "$item: $newtodo"
    [[ $TODOTXT_VERBOSE = 1 ]] && echo "TODO: $item marked as done."

    if [ $TODOTXT_AUTO_ARCHIVE = 1 ]; then
        archive
    fi
    cleanup ;;


"list" | "ls" )
    item=$2
    if [ -z "$item" ]; then
        echo -e "$(                                             \
            sed = "$TODO_FILE"                                  \
            | sed 'N; s/^/  /; s/ *\(.\{2,\}\)\n/\1 /'          \
            | sed 's/^ /0/'                                     \
            | sort -f -k2                                       \
            | sed '/^[0-9][0-9] x /! {
                s/\(.*(A).*\)/'$PRI_A'\1 '$DEFAULT'/g;
                s/\(.*(B).*\)/'$PRI_B'\1 '$DEFAULT'/g;
                s/\(.*(C).*\)/'$PRI_C'\1 '$DEFAULT'/g;
                s/\(.*([D-Z]).*\)/'$PRI_X'\1 '$DEFAULT'/g;
              }'                                                \
            | sed 's/'${HIDE_PRIORITY_SUBSTITUTION:-^}'//g'     \
            | sed 's/'${HIDE_PROJECTS_SUBSTITUTION:-^}'//g'     \
            | sed 's/'${HIDE_CONTEXTS_SUBSTITUTION:-^}'//g'     \
        )"
        echo "--"
        NUMTASKS=$(wc -l "$TODO_FILE" | sed 's/^[[:space:]]*\([0-9]*\).*/\1/')
        echo "TODO: $NUMTASKS tasks in $TODO_FILE."
    else
        command=$( 
            sed = "$TODO_FILE"                              \
            | sed 'N; s/^/  /; s/ *\(.\{2,\}\)\n/\1 /'      \
            | sed 's/^ /0/'                                 \
            | sort -f -k2                                   \
            | sed '/^[0-9][0-9] x /! {
                s/\(.*(A).*\)/'$PRI_A'\1 '$DEFAULT'/g;
                s/\(.*(B).*\)/'$PRI_B'\1 '$DEFAULT'/g;
                s/\(.*(C).*\)/'$PRI_C'\1 '$DEFAULT'/g;
                s/\(.*([D-Z]).*\)/'$PRI_X'\1 '$DEFAULT'/g;
              }'                                            \
            | grep -i $item
        )
        shift
        shift
        for i in $*
        do
            command=`echo "$command" | grep -i $i `
        done
        command=$(                                              \
            echo "$command"                                     \
            | sort -f -k2                                       \
            | sed 's/'${HIDE_PRIORITY_SUBSTITUTION:-^}'//g'     \
            | sed 's/'${HIDE_PROJECTS_SUBSTITUTION:-^}'//g'     \
            | sed 's/'${HIDE_CONTEXTS_SUBSTITUTION:-^}'//g'     \
        )
        echo -e "$command"
    fi
    cleanup ;;

"listall" | "lsa" )
    item=$2
    cat "$TODO_FILE" "$DONE_FILE" > "$TMP_FILE"

    if [ -z "$item" ]; then
        echo -e "`sed = "$TMP_FILE" | sed 'N; s/^/  /; s/ *\(.\{3,\}\)\n/\1 /' | sed 's/^  /00/' | sed 's/^ /0/' | sort -f -k2 | sed '/^[0-9][0-9][0-9] x /!s/\(.*(A).*\)/'$PRI_A'\1'$DEFAULT'/g' | sed '/^[0-9][0-9][0-9] x /!s/\(.*(B).*\)/'$PRI_B'\1'$DEFAULT'/g' | sed '/^[0-9][0-9][0-9] x /!s/\(.*(C).*\)/'$PRI_C'\1'$DEFAULT'/g' | sed '/^[0-9][0-9][0-9] x /!s/\(.*([A-Z]).*\)/'$PRI_X'\1'$DEFAULT'/'`"
    else
        command=`sed = "$TMP_FILE" | sed 'N; s/^/  /; s/ *\(.\{3,\}\)\n/\1 /' | sed 's/^  /00/' | sed 's/^ /0/' | sort -f -k2 | sed '/^[0-9][0-9][0-9] x /!s/\(.*(A).*\)/'$PRI_A'\1'$DEFAULT'/g' | sed '/^[0-9][0-9][0-9] x /!s/\(.*(B).*\)/'$PRI_B'\1'$DEFAULT'/g' | sed '/^[0-9][0-9][0-9] x /!s/\(.*(C).*\)/'$PRI_C'\1'$DEFAULT'/g' | sed '/^[0-9][0-9][0-9] x /!s/\(.*([A-Z]).*\)/'$PRI_X'\1'$DEFAULT'/' | grep -i $item `
        shift
        shift
        for i in $*
        do
            command=`echo "$command" | grep -i $i `
        done
        command=`echo "$command" | sort -f -k2`
        echo -e "$command"
    fi
    cleanup ;;


"listfile" | "lf" )
    src="$TODO_DIR/$2"

    if [ -z "$3" ]; then
        item=""
    else
        item=$3
    fi
    if [ -f "$src" ]; then
        if [ -z "$item" ]; then
            echo -e "`sed = "$src" | sed 'N; s/^/  /; s/ *\(.\{2,\}\)\n/\1 /' | sed 's/^ /0/' | sort -f -k2 | sed '/^[0-9][0-9] x /!s/\(.*(A).*\)/'$PRI_A'\1'$DEFAULT'/g' | sed '/^[0-9][0-9] x /!s/\(.*(B).*\)/'$PRI_B'\1'$DEFAULT'/g' | sed '/^[0-9][0-9] x /!s/\(.*(C).*\)/'$PRI_C'\1'$DEFAULT'/g' | sed '/^[0-9][0-9] x /!s/\(.*([A-Z]).*\)/'$PRI_X'\1'$DEFAULT'/'`"
            if [ $TODOTXT_VERBOSE = 1 ]; then
                echo "--"
                NUMTASKS=$( sed '/./!d' "$src" | wc -l | sed 's/^[[:space:]]*\([0-9]*\).*/\1/')
                echo "TODO: $NUMTASKS lines in $src."
            fi
        else
            command=`sed = "$src" | sed 'N; s/^/  /; s/ *\(.\{2,\}\)\n/\1 /' | sed 's/^ /0/' | sort -f -k2 | sed '/^[0-9][0-9] x /!s/\(.*(A).*\)/'$PRI_A'\1'$DEFAULT'/g' | sed '/^[0-9][0-9] x /!s/\(.*(B).*\)/'$PRI_B'\1'$DEFAULT'/g' | sed '/^[0-9][0-9] x /!s/\(.*(C).*\)/'$PRI_C'\1'$DEFAULT'/g' | sed '/^[0-9][0-9] x /!s/\(.*([A-Z]).*\)/'$PRI_X'\1'$DEFAULT'/' | grep -i $item `
            shift
            shift
            for i in $*
            do
                command=`echo "$command" | grep -i $i `
            done
            command=`echo "$command" | sort -f -k2`
            echo -e "$command"
        fi
    else
        echo "TODO: File $src does not exist."
    fi
    cleanup ;;

"listcon" | "lsc" )
    gawk '{for(i = 1; i <= NF; i++) print $i}' "$TODO_FILE" | grep '@' | sort | uniq
    cleanup ;;

"listproj" | "lsprj" )
    gawk '{for(i = 1; i <= NF; i++) print $i}' "$TODO_FILE" | grep '+' | sort | uniq
    cleanup ;;


"listpri" | "lsp" )
    pri=$( printf "%s\n" "$2" | tr 'a-z' 'A-Z' )
    errmsg="usage: $0 listpri PRIORITY
note:  PRIORITY must a single letter from A to Z."

    if [ -z "$pri" ]; then
        echo -e "`sed = "$TODO_FILE" | sed 'N; s/^/  /; s/ *\(.\{2,\}\)\n/\1 /' | sed 's/^ /0/' | sort -f -k2 |  sed 's/^ /0/' | sort -f -k2 | sed '/^[0-9][0-9] x /!s/\(.*(A).*\)/'$PRI_A'\1'$DEFAULT'/g' | sed '/^[0-9][0-9] x /!s/\(.*(B).*\)/'$PRI_B'\1'$DEFAULT'/g' | sed '/^[0-9][0-9] x /!s/\(.*(C).*\)/'$PRI_C'\1'$DEFAULT'/g' | sed '/^[0-9][0-9] x /!s/\(.*([A-Z]).*\)/'$PRI_X'\1'$DEFAULT'/'`" | grep \([A-Z]\)
        if [ $TODOTXT_VERBOSE = 1 ]; then
            echo "--"
            NUMTASKS=$(grep \([A-Z]\) "$TODO_FILE" | wc -l | sed 's/^[[:space:]]*\([0-9]*\).*/\1/')
            echo "TODO: $NUMTASKS prioritized tasks in $TODO_FILE."
        fi
    else
        [[ "$pri" = +([A-Z]) ]] || die "$errmsg"

        echo -e "`sed = "$TODO_FILE" | sed 'N; s/^/  /; s/ *\(.\{2,\}\)\n/\1 /' | sed 's/^ /0/' |  sort -f -k2 |  sed 's/^ /0/' | sort -f -k2 | sed '/^[0-9][0-9] x /!s/\(.*(A).*\)/'$PRI_A'\1'$DEFAULT'/g' | sed '/^[0-9][0-9] x /!s/\(.*(B).*\)/'$PRI_B'\1'$DEFAULT'/g' | sed '/^[0-9][0-9] x /!s/\(.*(C).*\)/'$PRI_C'\1'$DEFAULT'/g' | sed '/^[0-9][0-9] x /!s/\(.*([A-Z]).*\)/'$PRI_X'\1'$DEFAULT'/'`" | grep \($pri\)
        if [ $TODOTXT_VERBOSE = 1 ]; then
            echo "--"
            NUMTASKS=$(grep \($pri\) "$TODO_FILE" | wc -l | sed 's/^[[:space:]]*\([0-9]*\).*/\1/')
            echo "TODO: $NUMTASKS tasks prioritized $pri in $TODO_FILE."
        fi
    fi
    cleanup;;

"move" | "mv" )
    # replace moved line with a blank line when TODOTXT_PRESERVE_LINE_NUMBERS is 1
    errmsg="usage: $0 mv ITEM# DEST [SRC]"
    item=$2
    dest="$TODO_DIR/$3"
    src="$TODO_DIR/$4"

    [ -z "$item" ] && die "$errmsg"
    [ -z "$4" ] && src="$TODO_FILE"
    [ -z "$dest" ] && die "$errmsg"

    [[ "$item" = +([0-9]) ]] || die "$errmsg"

    if [ -f "$src" ]; then
        if [ -f "$dest" ]; then
            if sed -ne "$item p" "$src" | grep "^."; then
                MOVEME=$(sed "$item!d" "$src")
                if  [ $TODOTXT_FORCE = 0 ]; then
                    echo "Move '$MOVEME' from $src to $dest? (y/n)"
                    read ANSWER
                else
                    ANSWER="y"
                fi
                if [ "$ANSWER" = "y" ]; then
                    if [ $TODOTXT_PRESERVE_LINE_NUMBERS = 0 ]; then
                        # delete line (changes line numbers)
                        sed -i.bak -e $item"s/^.*//" -e '/./!d' "$src"
                    else
                        # leave blank line behind (preserves line numbers)
                       sed -i.bak -e $item"s/^.*//" "$src"
                    fi
                    echo "$MOVEME" >> "$dest"

                    [[ $TODOTXT_VERBOSE = 1 ]] && echo "TODO:  '$MOVEME' moved from '$src' to '$dest'."
                    cleanup
                else
                    echo "TODO:  No tasks moved."
                fi
            else
                echo "$item: No such item in $src."
            fi
        else
            echo "TODO:  Destination file $dest does not exist."
        fi
    else
        echo "TODO: Source file $src does not exist."
    fi
    cleanup;;

"prepend" | "prep" )
    errmsg="usage: $0 prepend ITEM# \"TEXT TO PREPEND\""
    shift; item=$1; shift

    [ -z "$item" ] && die "$errmsg"
    [[ "$item" = +([0-9]) ]] || die "$errmsg"

    todo=$(sed "$item!d" "$TODO_FILE")
    [ -z "$todo" ] && die "$item:  No such todo."

    if [[ -z "$1" && $TODOTXT_FORCE = 0 ]]; then
        echo -n "Prepend: "
        read input
    else
        input=$*
    fi

    if sed -i.bak $item" s|^.*|$input &|" "$TODO_FILE"; then
        newtodo=$(sed "$item!d" "$TODO_FILE")
        [[ $TODOTXT_VERBOSE = 1 ]] && echo "$item: $newtodo"
    else
        echo "TODO:  Error prepending task $item."
    fi
    cleanup;;

"pri" | "p" )
    item=$2
    newpri=$( printf "%s\n" "$3" | tr 'a-z' 'A-Z' )

    errmsg="usage: $0 pri ITEM# PRIORITY
note:  PRIORITY must be anywhere from A to Z."

    [ "$#" -ne 3 ] && die "$errmsg"
    [[ "$item" = +([0-9]) ]] || die "$errmsg"
    [[ "$newpri" = +([A-Z]) ]] || die "$errmsg"

    sed -e $item"s/^(.*) //" -e $item"s/^/($newpri) /" "$TODO_FILE" > /dev/null 2>&1

    if [ "$?" -eq 0 ]; then
        #it's all good, continue
        sed -i.bak -e $2"s/^(.*) //" -e $2"s/^/($newpri) /" "$TODO_FILE"
        NEWTODO=$(sed "$2!d" "$TODO_FILE")
        [[ $TODOTXT_VERBOSE = 1 ]] && echo -e "`echo "$item: $NEWTODO"`"
        [[ $TODOTXT_VERBOSE = 1 ]] && echo "TODO: $item prioritized ($newpri)."
        cleanup
    else
        die "$errmsg"
    fi;;

"replace" )
    errmsg="usage: $0 replace ITEM# \"UPDATED ITEM\""
    shift; item=$1; shift

    [ -z "$item" ] && die "$errmsg"
    [[ "$item" = +([0-9]) ]] || die "$errmsg"

    todo=$(sed "$item!d" "$TODO_FILE")
    [ -z "$todo" ] && die "$item:  No such todo."

    if [[ -z "$1" && $TODOTXT_FORCE = 0 ]]; then
        echo -n "Replacement: "
        read input
    else
        input=$*
    fi

    sed -i.bak $item" s|^.*|$input|" "$TODO_FILE"
    [[ $TODOTXT_VERBOSE = 1 ]] && NEWTODO=$(head -$item "$TODO_FILE" | tail -1)
    [[ $TODOTXT_VERBOSE = 1 ]] && echo "replaced with"
    [[ $TODOTXT_VERBOSE = 1 ]] && echo "$item: $NEWTODO"
    cleanup;;

"report" )
    #archive first
    sed '/^x /!d' "$TODO_FILE" >> "$DONE_FILE"
    sed -i.bak '/^x /d' "$TODO_FILE"

    NUMLINES=$(wc -l "$TODO_FILE" | sed 's/^[[:space:]]*\([0-9]*\).*/\1/')
    if [ $NUMLINES = "0" ]; then
         echo "datetime todos dones" >> "$REPORT_FILE"
    fi
    #now report
    TOTAL=$(cat "$TODO_FILE" | wc -l | sed 's/^[ \t]*//')
    TDONE=$(cat "$DONE_FILE" | wc -l | sed 's/^[ \t]*//')
    TECHO=$(echo $(date +%Y-%m-%d-%T); echo ' '; echo $TOTAL; echo ' ';
    echo $TDONE)
    echo $TECHO >> "$REPORT_FILE"
    [[ $TODOTXT_VERBOSE = 1 ]] && echo "TODO:  Report file updated."
    cat "$REPORT_FILE"
    cleanup;;

* )
    usage
    ;;
esac
