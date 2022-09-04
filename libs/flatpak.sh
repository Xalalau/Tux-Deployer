function isFlatpakInstalled() {
    # $1 = "package" or "remote package"
    local package="$(echo "$1" | awk '{print $NF}')"

    if [ "$(flatpak list | grep "$package")" != "" ]; then
        return 1
    fi

    return 0
}

function installFlatpak() {
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
                printfInfo "Installed flatpak: \"$package\""
            else
                printfError "Failed to install flatpak: \"$package\""
            fi
        fi
    done
}
