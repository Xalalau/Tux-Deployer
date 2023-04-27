function installAPTDependency() {
    local command=$1
    local package=$2
    local installed_dependencies=$3

    commandExists "$command"
    if [ "$?" -ne 1 ]; then
        if [ "$installed_dependencies" -eq 0 ]; then
            upgradeApt
        fi

        installApt "$package"

        commandExists "$command"
        if [ "$?" -ne 1 ]; then
            printfCritical "$package is needed in order to execute the script"
        fi

        return 1
    fi

    return 0
}

function checkDependencies() {
    sleep 0.3
    printfInfo "Checking script dependencies"

    local installed_dependencies=0

    installAPTDependency 'awk' 'awk' $installed_dependencies
    if [ "$?" -eq 1 ]; then
        installed_dependencies=1
    fi

    installAPTDependency 'curl' 'curl' $installed_dependencies
    if [ "$?" -eq 1 ]; then
        installed_dependencies=1
    fi

    installAPTDependency 'unzip' 'unzip' $installed_dependencies
    if [ "$?" -eq 1 ]; then
        installed_dependencies=1
    fi

    installAPTDependency 'unrar' 'unrar' $installed_dependencies
    if [ "$?" -eq 1 ]; then
        installed_dependencies=1
    fi

    if [ $ENABLE_FLATPAK -eq 1 ]; then
        installAPTDependency 'flatpak' 'flatpak' $installed_dependencies
        if [ "$?" -eq 1 ]; then
            installed_dependencies=1
        fi
    fi

    if [ $ENABLE_SNAP -eq 1 ]; then
        commandExists "snap" 

        if [ "$?" -ne 1 ]; then
            if [ -f "/etc/apt/preferences.d/nosnap.pref" ]; then # Linux Mint
                sudo rm "/etc/apt/preferences.d/nosnap.pref"
                sudo apt update &>>"$FILE_LOG";
            fi

            installAPTDependency 'snap' 'snapd' $installed_dependencies
            if [ "$?" -eq 1 ]; then
                installed_dependencies=1
            fi
        fi
    fi

    if [ $ENABLE_GDRIVE_DOWNLOAD_URLS -eq 1 ]; then
        installAPTDependency 'pip3' 'python3-pip' $installed_dependencies
        if [ "$?" -eq 1 ]; then
            installed_dependencies=1
        fi

        commandExists "gdown"
        if [ "$?" -ne 1 ]; then
            printfInfo "Installing: gdown"
            sudo pip3 install gdown &>>"$FILE_LOG";
            commandExists "gdown"
            if [ "$?" -ne 1 ]; then
                printfError "Failed to install: gdown"
                printfCritical "gdown is needed in order to execute the script"
            else
                printfDebug "Installed: gdown"
            fi
            installed_dependencies=1
        fi
    fi

    printfDebug "All done"

    if [ $installed_dependencies -eq 1 ]; then
        sleep 1
        clear -x
    else
        sleep 0.3
        clear
    fi

    sleep 0.3
}
