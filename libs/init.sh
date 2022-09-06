#!/bin/bash
SCRIPT_NAME="Tux Deployer"
SCRIPT_LICENSE="""
    MIT License - Xalalau Xubilozo
    Version 2.+.+ - 09/03/22 (mm/dd/yy)
    https://github.com/Xalalau/Tux-Deployer
"""

source /etc/upstream-release/lsb-release #DISTRIB_ID, DISTRIB_RELEASE, DISTRIB_CODENAME, DISTRIB_DESCRIPTION
source "$DIR_BASE/config.sh"

NOW="$(date)"
NOW_FORMATED="$(echo $NOW | tr -s '[:blank:]' '_')"

DIR_LIBS="$DIR_BASE/libs"
DIR_LOGS="$DIR_BASE/logs"
DIR_SCRIPTS="$DIR_BASE/scripts"
DIR_DOWNLOADS="$(xdg-user-dir DOWNLOAD)"
DIR_NETWORK="/etc/netplan"

FILE_LOG="$DIR_LOGS/$NOW_FORMATED.txt"

COLOR_BACKGROUND="\033[40m" # Magenta

COLOR_DEBUG="\e[1;37m" # White
COLOR_INFO="\e[1;36m" # Cyan
COLOR_WARNING="\e[1;33m" # Yellow
COLOR_FAILED="\e[1;31m" # Red
COLOR_CRITICAL="\e[1;31m" # Red
COLOR_HR="\e[1;32m" # Green

{ # Init
    cd "$DIR_LIBS"
    for file in *; do
        if [ $file != "init.sh" ]; then
            source "$file"
        fi
    done

    if [ $DISTRIB_ID != "Ubuntu" ]; then
        printfCritical "Tux Deployer only supports Ubuntu."
        exit
    fi

    if [ "$DISTRIB_CODENAME" != "focal" ] && [ "$DISTRIB_CODENAME" != "jammy" ]; then
        printfWarning "Warning! This script was tested on Ubuntu 20.04 (focal) and Ubuntu 22.04 (jammy), so tweaks may be needed in your version ($DISTRIB_CODENAME)."
    fi

    echo "" > "$FILE_LOG"

    cd "$DIR_BASE"

    ARCH="$(dpkg --print-architecture)"

    USER="$(whoami)"

    FILE_NETPLAN="$(cd "$DIR_NETWORK"; for dir in *; do echo "$DIR_NETWORK/$dir"; done;)"

	NETWORK_INTERFACE="$(ip route | awk '/default/ {print $5; exit}')"
	NETWORK_RENDERER="$(cat "$FILE_NETPLAN" | awk '/renderer/ {print $2; exit}')"
    GATEWAY="$(ip route | awk '/default/ {print $3; exit}')"
	INTERNAL_IP="$(hostname -I | cut -d' ' -f1)"
	SUBNET=$(ip route | awk '/proto/ && !/default/ {print $1}' | cut -d '/' -f2)

	read MAC </sys/class/net/$NETWORK_INTERFACE/address
	MAC_FORMATTED_LOWERCASE="$(echo $MAC | tr -d :)"
	MAC_FORMATTED_UPPERCASE="${MAC_FORMATTED_LOWERCASE^^}"

    if [ ${DISTRIB_RELEASE:0:2} -ge 22 ]; then
        IS_APT_KEY_DEPRECATED=1
    else
        export APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1 # Hide a warning since Ubuntu 18.04
        IS_APT_KEY_DEPRECATED=0
    fi

	printfWarning "To stop the installation at any time, press CTRL+C."
	printfWarning "Press any key to start."
    read -r TEMP

    sudo clear

    printfHr "$SCRIPT_NAME"
    printfHr """$SCRIPT_LICENSE"""
    printfInfo "    Log: $NOW_FORMATED.txt"
    echo

    commandExists "unzip"
    if [ "$?" -ne 1 ]; then
        installApt "unzip"
    fi

    commandExists "unrar"
    if [ "$?" -ne 1 ]; then
        installApt "unrar"
    fi

    if [ $ENABLE_FLATPAK -eq 1 ]; then
        commandExists "flatpak"
        if [ "$?" -ne 1 ]; then
            installApt "flatpak"
        fi
    fi

    if [ $ENABLE_SNAP -eq 1 ]; then
        commandExists "snap"

        if [ "$?" -ne 1 ]; then
            if [ -f "/etc/apt/preferences.d/nosnap.pref" ]; then # Hi, Linux Mint
                sudo rm "/etc/apt/preferences.d/nosnap.pref"
                sudo apt update &>>"$FILE_LOG";
            fi
            installApt "snapd"
        fi
    fi
}
