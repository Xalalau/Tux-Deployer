function run() {
    # $1 = Bash command
    # Returns: 1 [No errors] / 0 [Errors occurred]
    local error=$( ( ($1) 1 >> "$FILE_LOG" ) 2>&1 )

    if [ "$error" != "" ]; then
        echo $error &>>"$FILE_LOG";
        return 0
    else
        return 1
    fi
}

function createDir() {
    # $1 = Directory
    if [ -d "$1" ]; then
        printfDebug "Already created \"$1\""
    else
        mkdir -p "$1"
        printfDebug "\"$1\" created"
    fi
}

function createDirSudo() {
    # $1 = Directory
    if [ -d "$1" ]; then
        printfDebug "Already created \"$1\""
    else
        sudo mkdir -p "$1"
        printfDebug "\"$1\" created"
    fi
}

function commandExists() {
    # $1 = Command
    # Returns: 1 [Found] / 0 [Not found]
    type $1 >/dev/null 2>&1 && { 
        return 1
    } || {
        return 0
    }
}
