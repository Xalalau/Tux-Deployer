#!/bin/bash
SCRIPT_NAME="Tux Deployer"
SCRIPT_LICENSE="""
    MIT License - Xalalau Xubilozo
    Version 2.+.+ - // (mm/dd/yy)
    https://github.com/Xalalau/Tux-Deployer
"""

cd "$DIR_BASE"

#DISTRIB_ID, DISTRIB_RELEASE, DISTRIB_CODENAME, DISTRIB_DESCRIPTION
if [ -f "/etc/upstream-release/lsb-release" ]; then # Linux Mint
    source "/etc/upstream-release/lsb-release"
else
    source "/etc/lsb-release"
fi

NOW="$(date)"
NOW_FORMATED="$(echo $NOW | tr -s '[:blank:]' '_')"

DIR_INIT="$DIR_BASE/init"
DIR_LIBS="$DIR_BASE/libs"
DIR_LOGS="$DIR_BASE/logs"
DIR_SCRIPTS="$DIR_BASE/scripts"
DIR_CONFIGS="$DIR_BASE/configs"
DIR_NETWORK="/etc/netplan"

FILE_DEPENDENCIES="$DIR_INIT/dependencies.sh"
FILE_LOG="$DIR_LOGS/$NOW_FORMATED.txt"
FILE_CONFIG="$DIR_CONFIGS/config.sh"
FILE_NETPLAN=""

if [ -f "$DIR_NETWORK" ] && [ "$(ls -p $DIR_NETWORK | grep -v /)" ]; then
    FILE_NETPLAN="$(cd "$DIR_NETWORK"; for file in *; do echo "$DIR_NETWORK/$file"; done;)"
fi

ARCH="$(dpkg --print-architecture)"

USER_CURRENT="$(whoami)"

if [ ${DISTRIB_RELEASE:0:2} -ge 22 ]; then
    IS_APT_KEY_DEPRECATED=1
else
    export APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1 # Hide a warning since Ubuntu 18.04
    IS_APT_KEY_DEPRECATED=0
fi

source "$FILE_DEPENDENCIES"
source "$FILE_CONFIG"

for file in $DIR_LIBS/*; do
    source "$file"
done

NETWORK_INTERFACE="$(getActiveNetworkInterface)"
NETWORK_RENDERER="$(getNetworkRenderer)"
GATEWAY="$(getGateway)"
IP_INTERNAL="$(getInternalIP)"
SUBMASK="$(getCurrentSubmaskBits $NETWORK_INTERFACE)"

MAC="$(getNetworkInterfaceMAC $NETWORK_INTERFACE)"
MAC_FORMATTED_LOWERCASE="$(echo $MAC | tr -d :)"
MAC_FORMATTED_UPPERCASE="${MAC_FORMATTED_LOWERCASE^^}"

if [ $DISTRIB_ID != "Ubuntu" ] && [ $DISTRIB_ID != "Pop" ]; then
    printfCritical "Tux Deployer only supports Ubuntu and Pop."
    exit
fi

if [ "$DISTRIB_CODENAME" != "focal" ] && [ "$DISTRIB_CODENAME" != "jammy" ]; then
    printfWarning "Warning! This script was tested on Ubuntu 20.04 (focal) and Ubuntu 22.04 (jammy), so tweaks may be needed in your version ($DISTRIB_CODENAME)."
fi

mkdir -p "$DIR_LOGS"
echo "" > "$FILE_LOG"

sudo clear

checkDependencies

printfHr "$SCRIPT_NAME"
printfHr """$SCRIPT_LICENSE"""
printfInfo "    Log: $NOW_FORMATED.txt"
echo
printfWarning "    To stop the installation at any time, press CTRL+C."
echo
