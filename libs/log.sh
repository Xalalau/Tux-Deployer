function printfDebug() {
    # $1 = Message
    if [ $DEBUG -eq 1 ]; then
        printf "$COLOR_BACKGROUND$COLOR_DEBUG%s\e[m\e[m\n" "$1"
    fi
}

function printfInfo() {
    # $1 = Message
    printf "$COLOR_BACKGROUND$COLOR_INFO%s\e[m\e[m\n" "$1"
}

function printfWarning() {
    # $1 = Message
    printf "$COLOR_BACKGROUND$COLOR_WARNING%s\e[m\e[m\n" "$1"
}

function printfError() {
    # $1 = Message
    printf "$COLOR_BACKGROUND$COLOR_FAILED%s\e[m\e[m\n" "$1"

    if [ $HALT_ON_FAILED -eq 1 ]; then
        exit
    fi
}

function printfCritical() {
    # $1 = Message
    printf "\e[4m$COLOR_BACKGROUND$COLOR_CRITICAL%s\e[m\e[m\e[0m\n" "$1"

    if [ $HALT_ON_CRITICAL -eq 1 ]; then
        exit
    fi
}

function printfHr() {
    # $1 = Message
    printf "$COLOR_BACKGROUND$COLOR_HR%s\e[m\e[m\n" "$1"
}