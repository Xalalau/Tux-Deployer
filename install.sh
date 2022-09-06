### Initialization !!! Do not touch ### ----------------------
DIR_BASE="$(cd "${0%/*}" && echo $PWD)"
source "$DIR_BASE/libs/init.sh"
### Initialization !!! Do not touch ### ----------------------


addPPAKey "winehq-archive" "https://dl.winehq.org/wine-builds/winehq.key" "key"
addPPAKey "Google Inc." "https://dl.google.com/linux/linux_signing_key.pub"
addPPAKey "VirtualBox" "https://www.virtualbox.org/download/oracle_vbox_2016.asc"
addPPAKeyFromKeyServer "Insynchq" "keyserver.ubuntu.com" "ACCAF35C"

addPPALaunchpad "grub-customizer" "ppa:danielrichter2007/grub-customizer"
#addPPALaunchpad "oibaf" "ppa:oibaf/graphics-drivers"
addPPALaunchpad "telegram" "ppa:atareao/telegram"
addPPALaunchpad "lutris" "ppa:lutris-team/lutris"
addPPALaunchpad "kdenlive" "ppa:kdenlive/kdenlive-stable"
addPPALaunchpad "qbittorrent" "ppa:qbittorrent-team/qbittorrent-stable"
#addPPALaunchpad "haguichi" "ppa:webupd8team/haguichi"
#addPPALaunchpad "simplescreenrecorder" "ppa:maarten-baert/simplescreenrecorder"
#addPPALaunchpad "tlp" "ppa:linrunner/tlp"
#addPPALaunchpad "mainline" "ppa:cappelikan/ppa" # Ukuu, now mainline
addPPA "VirtualBox" "deb http://download.virtualbox.org/virtualbox/debian $DISTRIB_CODENAME contrib"
addPPA "Insynchq" "deb http://apt.insync.io/ubuntu $DISTRIB_CODENAME non-free contrib"
download "winehq-$DISTRIB_CODENAME.sources" "/etc/apt/sources.list.d" "https://dl.winehq.org/wine-builds/ubuntu/dists/$DISTRIB_CODENAME/winehq-$DISTRIB_CODENAME.sources" --ROOT

upgradeApt

acceptDebEULA "ttf-mscorefonts-installer" "msttcorefonts/accepted-mscorefonts-eula" "select" "true"
acceptDebEULA "steam" "steam/purge" "note" " "
acceptDebEULA "steam" "steam/license" "note" " "
acceptDebEULA "steam" "steam/question" "select" "I AGREE"

installDeb "appimagelauncherd" "https://github.com/TheAssassin/AppImageLauncher/releases/download/v2.2.0/appimagelauncher_2.2.0-travis995.0f91801.bionic_amd64.deb" # Check for updates
installDeb "code" "https://go.microsoft.com/fwlink/?LinkID=760868"
installDeb "discord" "https://discord.com/api/download?platform=linux&format=deb"
installDeb "google-chrome-stable" "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
#installDeb "skype" "https://repo.skype.com/latest/skypeforlinux-64.deb"
#installDeb "snes9x-gtk" "https://launchpad.net/ubuntu/+source/snes9x/1:1.52-1/+build/1687493/+files/snes9x-gtk_1.52-1_amd64.deb" # This version has working top menus
installDeb "steam" "http://ftp.br.debian.org/debian/pool/non-free/s/steam/steam_1.0.0.54-2_i386.deb" # This version accepts EULAs automation
installDeb "teamviewer" "https://download.teamviewer.com/download/linux/teamviewer_amd64.deb"

# Install stremio and its dependencies
installApt "nodejs" "qml-module-qtwebchannel" "libfdk-aac1"
installDeb "libfdk-aac1" "http://ftp.osuosl.org/pub/ubuntu/pool/multiverse/f/fdk-aac/libfdk-aac1_0.1.6-1_amd64.deb"
installDeb "stremio" "https://dl.strem.io/shell-linux/v4.4.159/stremio_4.4.159-1_amd64.deb" # Check for updates

installApt "axel"
installApt "audacity"
installApt "bleachbit"
installApt "blender"
installApt "build-essential"
#installApt "cheese"
installApt "default-jdk"
installApt "elementary-icon-theme"
installApt "filezilla"
installApt "g++-9"
installApt "g++-9-multilib"
installApt "gcc-9"
installApt "gcc-9-multilib"
installApt "gimp"
installApt "git"
installApt "gparted"
installApt "grub-customizer"
installApt "gscan2pdf"
installApt "insync"
installApt "jstest-gtk"
installApt "lutris"
#installApt "mainline" # Ukuu
installApt "mesa-utils"
installApt "mono-complete"
installApt "neofetch"
installApt "okular"
#installApt "openssh-server"
installApt "p7zip-full"
installApt "p7zip-rar"
installApt "pdfarranger"
installApt "ppa-purge"
installApt "qbittorrent"
installApt "qdirstat"
installApt "qjoypad"
installApt "rar"
installApt "simplescreenrecorder"
installApt "telegram-desktop"
#installApt "tlp"
installApt "unrar"
installApt "virtualbox"
installApt "vlc"
installApt "winbind"
installApt "winehq-staging"

download "Create_AP.zip" "/home/$USER/Applications/Create_AP" "https://codeload.github.com/oblique/create_ap/zip/master" --EXTRACT
download "Etcher.zip" "/home/$USER/Applications/Etcher" "https://github.com/balena-io/etcher/releases/download/v1.7.9/balena-etcher-electron-1.7.9-linux-x64.zip?d_id=b53962a5-eb91-4f24-8931-0d6cfe5e071fR" --EXTRACT # Check for updates
download "winetricks" "/usr/bin" "https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks" --ROOT

installFlatpak "flathub fr.handbrake.ghb"

runScript "libreoffice"
runScript "tlp"
runScript "wine"