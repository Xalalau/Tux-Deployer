function runScript() {
    # $1 = script filename
    # $2 = 0/1 silent include. Default 0
    local filename="$1"
    local silent="$2"

    if [ "$silent" = "" ] || [ $silent -eq 0 ]; then
        printfHr "Starting '$filename.sh'"
        . "$DIR_SCRIPTS/$filename.sh"
        printfHr "Finished '$filename.sh'"
    else
        . "$DIR_SCRIPTS/$filename.sh"
    fi
}
