function isSnapInstalled() {
    # $1 = "package" or "remote package"
    local package="$(echo "$1" | awk '{print $NF}')"

    if [ $ENABLE_SNAP -eq 0 ]; then
        printfDebug "Snap support is disabled"
        return
    fi

    if [ "$(snap list $package 2>/dev/null | grep $package)" != "" ]; then
        return 1
    fi

    return 0
}

function installSnap() {
    if [ $ENABLE_SNAP -eq 0 ]; then
        printfDebug "Snap support is disabled"
        return
    fi

    # ... = Packages
    for package in "$@"; do
        isSnapInstalled "$package"
        if [ "$?" -eq 1 ]; then
            printfDebug "Skipping snap: \"$package\""
        else
            printfInfo "Installing snap: \"$package\""
            sudo snap install $package &>>"$FILE_LOG";

            isSnapInstalled "$package"
            if [ "$?" -eq 1 ]; then
                printfDebug "Installed snap: \"$package\""
            else
                printfError "Failed to install snap: \"$package\""
            fi
        fi
    done
}
