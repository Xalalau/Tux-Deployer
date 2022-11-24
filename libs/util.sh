function run() {
    # $1 = Bash command
    # Returns: 1 [No errors] / 0 [Errors occurred]
    local error=$((($1) 1>>"$FILE_LOG";) 2>&1)

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

function addStringToFile() {
    # $1 = Target file
    # $2 = Term to be searched
    # $3 = String to be inserted
    local target="$1"
    local search_term="$(echo "$2" | sed -e 's/\//\\\//g')"
    local insert="$3"

    echo "$insert" | sudo tee -a "tempStrAppend.txt" > /dev/null
    sudo sed -E "/$search_term/r tempStrAppend.txt" "$target" | sudo tee -a "tempStrAppend2.txt" > /dev/null
    sudo mv "tempStrAppend2.txt" "$target"
    sudo rm "tempStrAppend.txt"
}

function replaceStringInFile() {
    # $1 = Term to be searched
    # $2 = String to be inserted
    # $3 = Target file
    local target="$1"
    local search_term="$(echo "$2" | sed -e 's/\//\\\//g')"
    local insert="$(echo "$3" | sed -e 's/\//\\\//g')"

    sudo cat "$target" | sudo sed -e "s/$search_term/$insert/" > "tempStrReplace.txt"
    sudo mv "tempStrReplace.txt" "$target"
}

function isStringEmpty() {
    # $1 = String
    # Returns: 1 [Empty] / 0 [Not empty]
    local trimmed=`echo $1`

    if [ -z "$trimmed" ]; then
        return 1
    else
        return 0
    fi
}