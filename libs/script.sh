function runScript() {
    # $1 = script filename
    printfHr "Starting '$1.sh'"
    source "$DIR_SCRIPTS/$1.sh"
    printfHr "Finished '$1.sh'"
}
