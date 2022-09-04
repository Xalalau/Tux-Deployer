function runScript() {
    # $1 = script filename
    
    printfHr "Running '$1.sh'"
    source "$DIR_SCRIPTS/$1.sh"
}
