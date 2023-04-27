#!/bin/bash
SCRIPT_NAME="Tux Deployer"
SCRIPT_LICENSE="""
    MIT License - Xalalau Xubilozo
    Version 2.+.+ - 11/29/22 (mm/dd/yy)
    https://github.com/Xalalau/Tux-Deployer
"""

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

#DISTRIB_ID, DISTRIB_RELEASE, DISTRIB_CODENAME, DISTRIB_DESCRIPTION
if [ -f "/etc/upstream-release/lsb-release" ]; then # Linux Mint
    source "/etc/upstream-release/lsb-release"
else
    source "/etc/lsb-release"
fi

NOW="$(date)"
NOW_FORMATED="$(echo $NOW | tr -s '[:blank:]' '_')"

DIR_LIBS="$DIR_BASE/libs"
DIR_LOGS="$DIR_BASE/logs"
DIR_SCRIPTS="$DIR_BASE/scripts"
DIR_CONFIGS="$DIR_BASE/configs"
DIR_NETWORK="/etc/netplan"

FILE_LOG="$DIR_LOGS/$NOW_FORMATED.txt"
FILE_NETPLAN="$(cd "$DIR_NETWORK"; for file in *; do echo "$DIR_NETWORK/$file"; done;)"

FILE_CONFIG="$DIR_CONFIGS/config.sh"

COLOR_BACKGROUND="\033[40m" # Magenta

STYLE_DEBUG="\e[1;37m" # White
STYLE_INFO="\e[1;36m" # Cyan
STYLE_WARNING="\e[1;33m" # Yellow
STYLE_FAILED="\e[1;31m" # Red
STYLE_CRITICAL="\e[1;31m" # Red
STYLE_HR="\e[1;32m" # Green
STYLE_TITLE="\e[4;1;32m" # Green + underline

ARCH="$(dpkg --print-architecture)"

USER_CURRENT="$(whoami)"

if [ ${DISTRIB_RELEASE:0:2} -ge 22 ]; then
    IS_APT_KEY_DEPRECATED=1
else
    export APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1 # Hide a warning since Ubuntu 18.04
    IS_APT_KEY_DEPRECATED=0
fi

source "$FILE_CONFIG"

cd "$DIR_LIBS"
for file in *; do
    if [ $file != "init.sh" ]; then
        source "$file"
    fi
done

NETWORK_INTERFACE="$(getActiveNetworkInterface)"
NETWORK_RENDERER="$(getNetworkRenderer)"
GATEWAY="$(getGateway)"
IP_INTERNAL="$(getInternalIP)"
SUBMASK="$(getCurrentSubmaskBits $NETWORK_INTERFACE)"

MAC="$(getNetworkInterfaceMAC $NETWORK_INTERFACE)"
MAC_FORMATTED_LOWERCASE="$(echo $MAC | tr -d :)"
MAC_FORMATTED_UPPERCASE="${MAC_FORMATTED_LOWERCASE^^}"

if [ $DISTRIB_ID != "Ubuntu" ]; then
    printfCritical "Tux Deployer only supports Ubuntu."
    exit
fi

if [ "$DISTRIB_CODENAME" != "focal" ] && [ "$DISTRIB_CODENAME" != "jammy" ]; then
    printfWarning "Warning! This script was tested on Ubuntu 20.04 (focal) and Ubuntu 22.04 (jammy), so tweaks may be needed in your version ($DISTRIB_CODENAME)."
fi

mkdir -p "$DIR_LOGS"
echo "" > "$FILE_LOG"

cd "$DIR_BASE"

sudo clear

checkDependencies

printfHr "$SCRIPT_NAME"
printfHr """$SCRIPT_LICENSE"""
printfInfo "    Log: $NOW_FORMATED.txt"
echo
printfWarning "    To stop the installation at any time, press CTRL+C."
echo
