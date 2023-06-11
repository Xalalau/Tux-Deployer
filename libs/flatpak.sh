function isFlatpakInstalled() {
    # $1 = "package" or "remote package"
    local package="$(echo "$1" | awk '{print $NF}')"

    if [ $ENABLE_FLATPAK -eq 0 ]; then
        printfDebug "Flatpak support is disabled"
        return
    fi

    if [ "$(flatpak list | grep "	$package	")" != "" ]; then
        return 1
    fi

    return 0
}

function addFlatpakRemote() {
    # $1 = Remote name
    # $2 = Remote url
    local remote_name="$1"
    local remote_url=$2

    if [ $ENABLE_FLATPAK -eq 0 ]; then
        printfDebug "Flatpak support is disabled"
        return
    fi

    if [ "$(flatpak remotes | grep "$remote_name	")" = "" ]; then
        printfInfo "Adding Flatpak remote: \"$remote_name\""
        sudo flatpak remote-add --if-not-exists "$remote_name" $remote_url
    else
        printfDebug "Skipping Flatpak remote: \"$remote_name\""
    fi
}

function installFlatpak() {
    if [ $ENABLE_FLATPAK -eq 0 ]; then
        printfDebug "Flatpak support is disabled"
        return
    fi

    # ... = Packages
    for package in "$@"; do
        isFlatpakInstalled "$package"
        if [ "$?" -eq 1 ]; then
            printfDebug "Skipping flatpak: \"$package\""
        else
            printfInfo "Installing flatpak: \"$package\""
            sudo flatpak install -y --noninteractive $package &>>"$FILE_LOG";

            isFlatpakInstalled "$package"
            if [ "$?" -eq 1 ]; then
                printfDebug "Installed flatpak: \"$package\""
            else
                printfError "Failed to install flatpak: \"$package\""
            fi
        fi
    done
}
