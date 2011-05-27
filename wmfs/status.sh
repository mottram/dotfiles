# Color definitions
color_default="\\#444444\\"
color_gray="\\#555555\\"

# Get the current date and time
_date()
{
    local date_now=$(date "+%d.%m.%Y %H:%M")

    date="${color_default}${date_now}"
}

statustext()
{
    for arg in $@; do
        _${arg}
        args="${args} $(eval echo '$'$arg)"
    done

    wmfs -s "$args"
}

statustext date
