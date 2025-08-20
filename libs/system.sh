function run() {
    # $1 = Bash command
    # Returns: 1 [No errors] / 0 [Errors occurred]
    local error=$((($1) 1>>"$FILE_LOG") 2>&1)


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

function addCronJob() {
    # $1 = New cronjob
    # $2 = Username (optional - default root)
    # Returns: 1 [Failed] / 0 [Success]
    local new_line="$1"
    local user="$2"

    if [[ -z "$user" ]]; then
        user="root"
    fi

    if ! id -u "$user" >/dev/null 2>&1; then
        printfError "User '$user' does not exist."
        return 1
    fi

    if [[ -z "$new_line" ]]; then
        printfError "Cron job not provided."
        return 1
    fi

    local cron="$(sudo crontab -u "$user" -l 2>/dev/null || true)"

    local updated_cron="$cron"
    if [[ "$cron" != *"$new_line"* ]]; then
        updated_cron+=$'\n'"$new_line"
    fi

    if [[ "$updated_cron" != "$cron" ]]; then
        echo "$updated_cron" | sudo crontab -u "$user" -
        printfDebug "Cron jobs updated for user \"$user\""
    else
        printfDebug "No new cron jobs to add for user \"$user\""
    fi

    return 0
}
