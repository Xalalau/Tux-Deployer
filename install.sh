### Initialization !!! Do not touch ### ----------------------
DIR_BASE="$(cd "${0%/*}" && echo $PWD)"
source "$DIR_BASE/init/init.sh"
### Initialization !!! Do not touch ### ----------------------


addPPAKey "winehq-archive" "/etc/apt/keyrings" "https://dl.winehq.org/wine-builds/winehq.key" "key"
addPPAKey "Google Inc." "/usr/share/keyrings" "https://dl.google.com/linux/linux_signing_key.pub"
addPPAKey "VirtualBox" "/usr/share/keyrings" "https://www.virtualbox.org/download/oracle_vbox_2016.asc"
addPPAKeyFromKeyServer "Insynchq" "/usr/share/keyrings" "keyserver.ubuntu.com" "ACCAF35C"

#addPPALaunchpad "grub-customizer" "ppa:danielrichter2007/grub-customizer"
#addPPALaunchpad "oibaf" "ppa:oibaf/graphics-drivers"
addPPALaunchpad "telegram" "ppa:atareao/telegram"
addPPALaunchpad "lutris" "ppa:lutris-team/lutris"
addPPALaunchpad "kdenlive" "ppa:kdenlive/kdenlive-stable"
addPPALaunchpad "qbittorrent" "ppa:qbittorrent-team/qbittorrent-stable"
addPPALaunchpad "apt-fast" "ppa:apt-fast/stable"
#addPPALaunchpad "haguichi" "ppa:webupd8team/haguichi"
#addPPALaunchpad "simplescreenrecorder" "ppa:maarten-baert/simplescreenrecorder"
#addPPALaunchpad "tlp" "ppa:linrunner/tlp"
#addPPALaunchpad "mainline" "ppa:cappelikan/ppa" # Ukuu, now mainline
addPPA "VirtualBox" "deb http://download.virtualbox.org/virtualbox/debian $DISTRIB_CODENAME contrib"
addPPA "Insynchq" "deb http://apt.insync.io/ubuntu $DISTRIB_CODENAME non-free contrib"
download "winehq-$DISTRIB_CODENAME.sources" "/etc/apt/sources.list.d" "https://dl.winehq.org/wine-builds/ubuntu/dists/$DISTRIB_CODENAME/winehq-$DISTRIB_CODENAME.sources" --ROOT

upgradeApt

installDeb "appimagelauncherd" "https://github.com/TheAssassin/AppImageLauncher/releases/download/v2.2.0/appimagelauncher_2.2.0-travis995.0f91801.bionic_amd64.deb" # Check for updates
installDeb "code" "https://go.microsoft.com/fwlink/?LinkID=760868"
installDeb "discord" "https://discord.com/api/download?platform=linux&format=deb"
installDeb "google-chrome-stable" "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
#installDeb "snes9x-gtk" "https://launchpad.net/ubuntu/+source/snes9x/1:1.52-1/+build/1687493/+files/snes9x-gtk_1.52-1_amd64.deb" # This version has working top menus
installDeb "teamviewer" "https://download.teamviewer.com/download/linux/teamviewer_amd64.deb"
installDeb "freedownloadmanager" "https://files2.freedownloadmanager.org/6/latest/freedownloadmanager.deb"

# Install Steam and its dependencies
acceptDebEULA "ttf-mscorefonts-installer" "msttcorefonts/accepted-mscorefonts-eula" "select" "true"
acceptDebEULA "steam" "steam/purge" "note" " "
acceptDebEULA "steam" "steam/license" "note" " "
acceptDebEULA "steam" "steam/question" "select" "I AGREE"
installDeb "steam-devices" "http://ftp.br.debian.org/debian/pool/non-free/s/steam/steam-devices_1.0.0.68-1_all.deb" # This version accepts EULAs automation
installDeb "steam" "http://ftp.br.debian.org/debian/pool/non-free/s/steam/steam_1.0.0.68-1_i386.deb" # This version accepts EULAs automation

# Install Stremio and its dependencies
installApt "nodejs" "qml-module-qtwebchannel"
installDeb "libfdk-aac1" "http://ftp.osuosl.org/pub/ubuntu/pool/multiverse/f/fdk-aac/libfdk-aac1_0.1.6-1_amd64.deb"
installDeb "stremio" "https://dl.strem.io/shell-linux/v4.4.160/stremio_4.4.160-1_amd64.deb" # Check for updates

# Install MultiMC and its dependencies
installApt "libqt5core5a" "libqt5network5" "libqt5gui5"
installDeb "multimc" "https://files.multimc.org/downloads/multimc_1.6-1.deb"

#installApt "axel"
installApt "apt-fast"
installApt "audacity"
installApt "bleachbit"
installApt "blender"
installApt "build-essential"
#installApt "cheese"
#installApt "default-jdk"
installApt "filezilla"
installApt "folder-color"
installApt "g++-12"
installApt "g++-12-multilib"
installApt "gcc-12"
installApt "gcc-12-multilib"
installApt "gimp"
installApt "git"
installApt "gparted"
#installApt "grub-customizer"
installApt "gscan2pdf"
installApt "insync"
installApt "jstest-gtk"
installApt "lutris"
#installApt "mainline" # Ukuu
installApt "mesa-utils"
installApt "mono-complete"
installApt "neofetch"
installApt "obs-studio"
installApt "okular"
installApt "openjdk-17-jdk"
installApt "openjdk-17-jre"
#installApt "openssh-server"
installApt "pdfarranger"
installApt "ppa-purge"
installApt "qbittorrent"
installApt "qdirstat"
installApt "qjoypad"
installApt "simplescreenrecorder"
installApt "telegram-desktop"
#installApt "tlp"
installApt "virtualbox"
installApt "vlc"
installApt "winbind"
installApt "winehq-staging"

#download "Create_AP.zip" "/home/$USER_CURRENT/Applications/Create_AP" "https://codeload.github.com/oblique/create_ap/zip/master" --EXTRACT-CLEAR
download "Etcher.zip" "/home/$USER_CURRENT/Applications/Etcher" "https://github.com/balena-io/etcher/releases/download/v1.7.9/balena-etcher-electron-1.7.9-linux-x64.zip?d_id=b53962a5-eb91-4f24-8931-0d6cfe5e071fR" --EXTRACT-CLEAR # Check for updates
download "winetricks" "/usr/bin" "https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks" --ROOT

installFlatpak "flathub fr.handbrake.ghb"
installFlatpak "flathub io.dbeaver.DBeaverCommunity"

#runScript "tlp_init"
runScript "wine_init"
