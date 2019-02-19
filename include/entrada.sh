# Funcionamento das chamadas de função

# CHAVES:
   # adicionarChave "SERVIDOR" "CHAVE" "RÓTULO QUALQUER" "TERMO DE BUSCA (atua em apt-key list)"
   # EX: adicionarChave "hkp://pgp.mit.edu:80" "379CE192D401AB61" "Etcher" "Bintray (by JFrog)"

   # adicionarChave2 "LINK_DOWNLOAD_CHAVE" "RÓTULO QUALQUER" "TERMO DE BUSCA (atua em apt-key list)"
   # EX: adicionarChave2 "https://dl.google.com/linux/linux_signing_key.pub" "Google Chrome" "Google Inc."

# PPAS:
   # adicionarPPA "PPA" "TERMO DE BUSCA (atua em /etc/apt/sources.list.d)"
   # Ex: adicionarPPA "ppa:webupd8team/y-ppa-manager" "y-ppa-manager"

   # adicionarPPA2 "COMANDO DEB DE ADIÇÃO DE REPOSITÓRIOS" "NOME_DO_ARQUIVO.list" "RÓTULO QUALQUER"
   # Ex: adicionarPPA2 "deb http://linux.dropbox.com/ubuntu/ $CODENOME main" "dropbox.list" "dropbox"

# EULAS:
   # aceitarEula "NOME DO PACOTE" "SEÇÃO" "ITEM" "VALOR"
   # EX: aceitarEula "steam" "steam/question" "select" "I AGREE"

# DEBS POR DOWNLOAD:
   # baixarDeb "NOME DO PACOTE" "LINK" --SUBSTRING
   # Ex: baixarDeb "steam-launcher" "https://steamcdn-a.akamaihd.net/client/installer/steam.deb"
   # NOTA: --SUBSTRING é opcional. Quando usado força a busca pelo pacote a retornar verdadeira caso
   #       qualquer substring igual a "NOME DO PACOTE" seja encontrada na nossa $LISTA.

# DEBS POR APT-GET:
   # instalarApt "NOME DO PACOTE" "PARÂMETROS" --SUBSTRING
   # Ex: instalarApt "build-essential" "--install-recommends --allow-unauthenticated"
   # Ex2: instalarApt "libc6-dev" --SUBSTRING
   # NOTA: --SUBSTRING é opcional. Quando usado força a busca pelo pacote a retornar verdadeira caso
   #       qualquer substring igual a "NOME DO PACOTE" seja encontrada na nossa $LISTA.

# PROGRAMAS AVULSOS:
   # baixarEExtrair "PASTA DESTINO" "EXTENSÃO" "LINK DE DOWNLOAD" --ROOT
   # Ex: baixarEExtrair "~/Create AP" "zip" "https://codeload.github.com/oblique/create_ap/zip/master"
   # Nota: a função extrai o conteúdo de arquivos zip, rar e tar.gz
   # NOTA: --ROOT é opcional. Faz os arquivos serem instalados pelo administrador.

# SCRIPTS:
    # rodarScript "NOME DO SCRIPT"
    # Ex: rodarScript "configurarWine"




function adicionarChaves() {
    adicionarChave2 "https://dl.winehq.org/wine-builds/Release.key" "Wine" "Wine"
    adicionarChave2 "https://dl.google.com/linux/linux_signing_key.pub" "Google Chrome" "Google Inc."
    adicionarChave2 "https://www.virtualbox.org/download/oracle_vbox_2016.asc" "VirtualBox" "VirtualBox"
    adicionarChave "keyserver.ubuntu.com" "ACCAF35C" "Insync" "Insynchq"
}

function adicionarPPAs() {
    adicionarPPA "ppa:atareao/telegram" "telegram"
    adicionarPPA "ppa:qbittorrent-team/qbittorrent-stable" "qbittorrent"
    adicionarPPA "ppa:webupd8team/haguichi" "haguichi"
    adicionarPPA "ppa:nilarimogard/webupd8" "webupd8" #freshplayer vem daqui
    adicionarPPA "ppa:maarten-baert/simplescreenrecorder" "simplescreenrecorder"
    adicionarPPA "ppa:linuxuprising/java" "java"
    adicionarPPA "ppa:danielrichter2007/grub-customizer" "grub-customizer"
    adicionarPPA "ppa:ermshiperete/monodevelop" "mono"
    adicionarPPA "ppa:linrunner/tlp" "tlp"
    adicionarPPA "ppa:dawidd0811/neofetch" "neofetch"
    adicionarPPA "ppa:webupd8team/indicator-kdeconnect" "kdeconnect"
    adicionarPPA "ppa:nathan-renniewaldock/qdirstat" "qdirstat"
    adicionarPPA "ppa:paulo-miguel-dias/mesa" "paulo-miguel-dias" # Gáficos open-source instáveis atualizados pelo Padoka
    adicionarPPA "ppa:stebbins/handbrake-releases" "handbrake"
    adicionarPPA "ppa:teejee2008/ppa" "teejee2008" # Kernels atualizados para o Ubuntu
    adicionarPPA2 "deb http://download.virtualbox.org/virtualbox/debian $CODENOME contrib" "virtualbox.list" "virtualbox"
    adicionarPPA2 "deb http://apt.insynchq.com/ubuntu $CODENOME non-free contrib" "insync.list" "insync" #DISTRIBUICAO só ubuntu, debian e mint
}

function aceitarEulas() {
    aceitarEula "oracle-java10-installer" "shared/accepted-oracle-license-v1-1" "select" "true"
    aceitarEula "ttf-mscorefonts-installer" "msttcorefonts/accepted-mscorefonts-eula" "select" "true"
    aceitarEula "steam" "steam/purge" "note" " "
    aceitarEula "steam" "steam/license" "note" " "
    aceitarEula "steam" "steam/question" "select" "I AGREE"
}

function instalarDebs() {
    instalarDeb "google-chrome-stable" "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
    instalarDeb "hamachi" "https://www.vpn.net/installers/logmein-hamachi_2.1.0.198-1_amd64.deb" # Verificar por updates
    instalarDeb "teamviewer" "https://download.teamviewer.com/download/linux/teamviewer_amd64.deb"
    instalarDeb "skypeforlinux" "https://repo.skype.com/latest/skypeforlinux-64-alpha.deb"
    instalarDeb "steam" "http://ftp.br.debian.org/debian/pool/non-free/s/steam/steam_1.0.0.54-2_i386.deb" # Esse consegue automatizar as EULAs
    instalarDeb "playonlinux" "https://www.playonlinux.com/script_files/PlayOnLinux/4.2.12/PlayOnLinux_4.2.12.deb" # Verificar por updates
    instalarDeb "code" "https://go.microsoft.com/fwlink/?LinkID=760868" # Visual Studio Code
    instalarDeb "discord" "https://dl.discordapp.net/apps/linux/0.0.6/discord-0.0.6.deb" # Verificar por updates
    instalarDeb "appimagelauncherd" "https://github.com/TheAssassin/AppImageLauncher/releases/download/continuous/appimagelauncher_1.0.3-travis505.git20190211.5791c72.bionic_amd64.deb" # Integrar appimages em bin, downloads etc.
}

function requisitosTtyecho() { 
    instalarApt "libc6-dev" --SUBSTRING
}

function instalacoesApt() {
    instalarApt "axel"
    instalarApt "android-tools-adb"
    instalarApt "android-tools-fastboot"
    instalarApt "audacity"
    instalarApt "blender"
    instalarApt "bleachbit"
    instalarApt "browser-plugin-freshplayer-pepperflash"
    instalarApt "build-essential"
    instalarApt "cifs-utils" # Para o Samba
    instalarApt "cheese"
    instalarApt "dropbox"
    instalarApt "elementary-icon-theme"
    instalarApt "filezilla"
    instalarApt "geany"
    instalarApt "geogebra"
    instalarApt "g++-7"
    instalarApt "g++-7-multilib"
    instalarApt "gcc-7"
    instalarApt "gcc-7-multilib"
    instalarApt "gimp"
    instalarApt "git"
    instalarApt "git-cola"
    instalarApt "gparted"
    instalarApt "grub-customizer"
    instalarApt "haguichi"
    instalarApt "hardinfo"
    instalarApt "handbrake-gtk"
    instalarApt "hostapd"
    instalarApt "hplip-gui"
    instalarApt "indicator-kdeconnect"
    instalarApt "insync"
    instalarApt "jstest-gtk"
    instalarApt "k3b"
    instalarApt "kde-runtime" # Ícones para o Kdenlive 
    instalarApt "kdeconnect"
    instalarApt "libavcodec-extra"
    instalarApt "libreoffice"
    instalarApt "mesa-utils"
    instalarApt "mono-complete"
    instalarApt "nemo-dropbox"
    instalarApt "numix-gtk-theme"
    instalarApt "neofetch"
    instalarApt "okular"
    instalarApt "openssh-server" # Para o XMouse
    instalarApt "oracle-java10-installer"
    instalarApt "oracle-java10-set-default"
    instalarApt "p7zip-full"
    instalarApt "p7zip-rar"
    instalarApt "ppa-purge"
    instalarApt "qbittorrent"
    instalarApt "qdirstat"
    instalarApt "qjoypad"
    instalarApt "rar"
    instalarApt "samba"
    instalarApt "simple-scan"
    instalarApt "simplescreenrecorder"
    instalarApt "simplescreenrecorder-lib:i386"
    instalarApt "synaptic"
    instalarApt "telegram-desktop"
    instalarApt "tlp"
    instalarApt "tlp-rdw"
    instalarApt "ukuu"
    instalarApt "unrar"
    instalarApt "virtualbox-5.2"
    instalarApt "vlc"
    instalarApt "winbind"
    instalarApt "wine-stable"
    instalarApt "xdotool" # Para o XMouse
    instalarApt "xterm"
}

function instalarAvulsos() {
    baixarEPosicionar "Create_AP" "zip" "~/Trecos/Create_AP" "https://codeload.github.com/oblique/create_ap/zip/master"
    baixarEPosicionar "Etcher" "appimage" "~/bin" "https://github.com/balena-io/etcher/releases/download/v1.4.9/balena-etcher-electron-1.4.9-linux-x64.zip"
    baixarEPosicionar "Stremio" "appimage" "~/bin" "https://dl.strem.io/linux/v4.4.25/stremio_4.4.25-1_amd64.deb" # Verificar por updates
    baixarEPosicionar "wine-mono-4.7.1" "msi" "~/.cache/wine" "http://dl.winehq.org/wine/wine-mono/4.8.0/wine-mono-4.8.0.msi" # Verificar por updates
    baixarEPosicionar "wine_gecko-2.47-x86" "msi" "~/.cache/wine" "http://dl.winehq.org/wine/wine-gecko/2.47/wine_gecko-2.47-x86.msi" # Verificar por updates
    baixarEPosicionar "winetricks" "" "/usr/bin" "https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks" --ROOT
    baixarEPosicionar "kdenlive-18.04.1-x86_64" "appimage" "~/bin" "https://files.kde.org/kdenlive/release/kdenlive-18.12.1b-x86_64.appimage" # Verificar por updates
}



function rodarScripts() {
    rodarScript "configurarTLP"
    rodarScript "configurarWine"
}




# Backup
# -----------------------------------------------------------------------------------------------------------

: ' #-------------------------------
    #Depósito de adições desativadas
    #-------------------------------

# CHAVES

    adicionarChave2 "https://dl.winehq.org/wine-builds/Release.key" "Wine" "Wine"

# PPAS
    adicionarPPA "ppa:ubuntu-toolchain-r/test" "toolchain" #GCC-7
    adicionarPPA "ppa:oibaf/graphics-drivers" "graphics-drivers" # Gáficos open-source instáveis atualizados pelo Oibaf
    adicionarPPA "ppa:paulo-miguel-dias/pkppa" "paulo-miguel" # Gáficos open-source estáveis atualizados pelo Padoka
    adicionarPPA2 "deb https://dl.winehq.org/wine-builds/ubuntu/ $CODENOME main" "wine-builds.list" "wine" # Wine oficial. Não usar junto com o Wine do gallium-nine.
    adicionarPPA "ppa:commendsarnex/winedri3" "winedri3" # Wine atualizado com gallium-nine para o Padoka e Oibaf
    adicionarPPA "ppa:webupd8team/java" "java"
    adicionarPPA "ppa:dolphin-emu/ppa" "dolphin-emu"
    adicionarPPA "ppa:webupd8team/y-ppa-manager" "y-ppa-manager"
    adicionarPPA "ppa:kdenlive/kdenlive-stable" "kdenlive"
    adicionarPPA "ppa:numix/ppa" "numix"

#EULAS
    
    xx

# DEBS POR DOWNLOAD NORMAL

    instalarDeb "snes9x-gtk" "https://launchpad.net/ubuntu/+source/snes9x/1:1.52-1/+build/1687493/+files/snes9x-gtk_1.52-1_amd64.deb" # Essa versão tem os menus da parte superior funcionais
    instalarDeb "spotifywebplayer" "https://github.com/Quacky2200/Spotify-Web-Player-for-Linux/releases/download/0.9.5-1/spotifywebplayerv0.9.5-1-alpha-x64.deb"
    instalarDeb "dropbox" "https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_2015.10.28_amd64.deb"

# DEBS POR APT-GET

    instalarApt "aptitude"
    instalarApt "breeze-cursor-theme" # Bonito
    instalarApt "dolphin-emu-master" #Emulador
    instalarApt "dolphin-plugins" #Para o gerenciador de arquivos dolphin
    instalarApt "fceux"
    instalarApt "furiusisomount"
    instalarApt "gscan2pdf"
    instalarApt "kdenlive"
    instalarApt "kdesudo"
    instalarApt "mupen64plus-qt"
    instalarApt "nautilus-dropbox" # Esse download do Dropbox funciona muito bem no Nautilus
    instalarApt "numix-icon-theme-circle"
    instalarApt "pdfshuffler"
    instalarApt "xscreensaver"
    instalarApt "xscreensaver-gl-extra"
    instalarApt "xscreensaver-data-extra"
    instalarApt "winehq-staging" "--install-recommends --allow-unauthenticated"
    instalarApt "winetricks"
    instalarApt "y-ppa-manager"

# PROGRAMAS AVULSOS

    xx
'

