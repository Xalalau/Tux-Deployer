function printfDebug() {
    # $1 = Message
    if [ $DEBUG -eq 1 ]; then
        printf "$COLOR_BACKGROUND$STYLE_DEBUG%s\e[m\e[m\n" "$1"
        echo $1 &>>"$FILE_LOG";
    fi
}

function printfInfo() {
    # $1 = Message
    printf "$COLOR_BACKGROUND$STYLE_INFO%s\e[m\e[m\n" "$1"
    echo $1 &>>"$FILE_LOG";
}

function printfWarning() {
    # $1 = Message
    printf "$COLOR_BACKGROUND$STYLE_WARNING%s\e[m\e[m\n" "$1"
    echo $1 &>>"$FILE_LOG";
}

function printfError() {
    # $1 = Message
    printf "$COLOR_BACKGROUND$STYLE_FAILED%s\e[m\e[m\n" "$1"
    echo $1 &>>"$FILE_LOG";

    if [ $HALT_ON_FAILED -eq 1 ]; then
        exit
    fi
}

function printfCritical() {
    # $1 = Message
    printf "\e[4m$COLOR_BACKGROUND$STYLE_CRITICAL%s\e[m\e[m\e[0m\n" "$1"
    echo $1 &>>"$FILE_LOG";

    if [ $HALT_ON_CRITICAL -eq 1 ]; then
        exit
    fi
}

function printfHr() {
    # $1 = Message
    printf "$COLOR_BACKGROUND$STYLE_HR%s\e[m\e[m\n" "$1"
    echo $1 &>>"$FILE_LOG";
}

function printfTitle() {
    # $1 = Message
    printf "$COLOR_BACKGROUND$STYLE_TITLE%s\e[m\e[m\n" "$1"
    echo $1 &>>"$FILE_LOG";
}