function printfDebug() {
    # $1 = Message
    local color_debug="\e[1;37m" # White
    if [ $DEBUG -eq 1 ]; then
        printf "\033[40m$color_debug%s\e[m\e[m\n" "$1"
        echo "Debug: $1" &>>"$FILE_LOG";
    fi
}

function printfInfo() {
    # $1 = Message
    local color_info="\e[1;36m" # Cyan
    printf "\033[40m$color_info%s\e[m\e[m\n" "$1"
    echo "Info: $1" &>>"$FILE_LOG";
}

function printfWarning() {
    # $1 = Message
    local color_warning="\e[1;33m" # Yellow
    printf "\033[40m$color_warning%s\e[m\e[m\n" "$1"
    echo "Warning: $1" &>>"$FILE_LOG";
}

function printfError() {
    # $1 = Message
    local color_failed="\e[1;31m" # Red

    printf "\033[40m$color_failed%s\e[m\e[m\n" "$1"
    echo "Error: $1" &>>"$FILE_LOG";

    if [ $HALT_ON_FAILED -eq 1 ]; then
        exit
    fi
}

function printfCritical() {
    # $1 = Message
    local color_critical="\e[1;31m" # Red

    printf "\e[4m\033[40m$color_critical%s\e[m\e[m\e[0m\n" "$1"
    echo "Critical: $1" &>>"$FILE_LOG";

    if [ $HALT_ON_CRITICAL -eq 1 ]; then
        exit
    fi
}

function printfHr() {
    # $1 = Message
    local color_hr="\e[1;32m" # Green
    printf "\033[40m$color_hr%s\e[m\e[m\n" "$1"
    echo "HR: $1" &>>"$FILE_LOG";
}

function printfTitle() {
    # $1 = Message
    local color_title="\e[4;1;32m" # Green + underline
    printf "\033[40m$color_title%s\e[m\e[m\n" "$1"
    echo "Title: $1" &>>"$FILE_LOG";
}