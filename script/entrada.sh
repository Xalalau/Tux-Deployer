# Funcionamento das chamadas de função

# CHAVES:
   # adicionarChave "SERVIDOR" "CHAVE" "RÓTULO QUALQUER" "TERMO DE BUSCA"
   # EX: adicionarChave "pgp.mit.edu" "5044912E" "Dropbox"
   # adicionarChave2 "LINK_DOWNLOAD_CHAVE" "RÓTULO QUALQUER" "TERMO DE BUSCA"
   # EX: adicionarChave2 "https://d2t3ff60b2tol4.cloudfront.net/services@insynchq.com.gpg.key" "Insync"

# PPAS:
   # adicionarPPA "PPA" "TERMO QUE PODE IDENTIFICÁ-LO EM /etc/apt/sources.list.d"
   # Ex: adicionarPPA "ppa:webupd8team/y-ppa-manager" "y-ppa-manager"
   # adicionarPPA2 "COMANDO DEB DE ADIÇÃO DE REPOSITÓRIOS" "NOME_DO_ARQUIVO.list" "RÓTULO QUALQUER"
   # Ex: adicionarPPA2 "deb http://linux.dropbox.com/ubuntu/ $CODENOME main" "dropbox.list" "dropbox"

# EULAS:
   # aceitarEula "NOME DO PACOTE" "SEÇÃO" "ITEM" "VALOR"
   # EX: aceitarEula "steam" "steam/question" "select" "I AGREE"

# DEBS POR DOWNLOAD:
   # baixarDeb "NOME DO PACOTE" "LINK" "TERMO DE BUSCA"
   # Ex: baixarDeb "steam-launcher" "https://steamcdn-a.akamaihd.net/client/installer/steam.deb"
   # NOTA: "TERMO DE BUSCA" é opcional. Deve ser usado para encontrar a instalação de pacotes que não
   #       estão sendo detectados normalmente.

# DEBS POR APT-GET:
   # instalarApt "NOME DO PACOTE" "ALGUM PARÂMETRO" "TERMO DE BUSCA"
   # Ex: instalarApt "build-essential" "--install-recommends"
   # NOTA: "TERMO DE BUSCA" é opcional. Deve ser usado para encontrar a instalação de pacotes que não
   #       estão sendo detectados normalmente.

# PROGRAMAS COMPACTADOS (EX: ZIP, RAR, TAR.GZ):
   # baixarEExtrair "NOME DA PASTA DESTINO" "EXTENSÃO" "LINK DE DOWNLOAD"
   # Ex: baixarEExtrair "Create AP" "zip" "https://codeload.github.com/oblique/create_ap/zip/master"




# --------------------
# Pacotes de: 23/09/17
# --------------------


function adicionarChaves() {
    adicionarChave2 "https://dl.google.com/linux/linux_signing_key.pub" "Google Chrome" "Google Inc."
    adicionarChave2 "https://www.virtualbox.org/download/oracle_vbox_2016.asc" "VirtualBox" "VirtualBox"
    adicionarChave "hkp://pgp.mit.edu:80" "379CE192D401AB61" "Etcher" "Bintray (by JFrog)"
}

function adicionarPPAs() {
    adicionarPPA "ppa:atareao/telegram" "telegram"
    adicionarPPA "ppa:qbittorrent-team/qbittorrent-stable" "qbittorrent"
    adicionarPPA "ppa:webupd8team/haguichi" "haguichi"
    adicionarPPA "ppa:nilarimogard/webupd8" "webupd8" #freshplayer vem daqui
    adicionarPPA "ppa:maarten-baert/simplescreenrecorder" "simplescreenrecorder"
    adicionarPPA "ppa:webupd8team/java" "java"
    adicionarPPA "ppa:danielrichter2007/grub-customizer" "grub-customizer"
    adicionarPPA "ppa:ermshiperete/monodevelop" "mono"
    adicionarPPA "ppa:linrunner/tlp" "tlp"
    adicionarPPA "ppa:kdenlive/kdenlive-stable" "kdenlive"
    adicionarPPA "ppa:dawidd0811/neofetch" "neofetch"
    adicionarPPA "ppa:paulo-miguel-dias/mesa" "paulo-miguel-dias"
    adicionarPPA "ppa:commendsarnex/winedri3" "winedri3" # Wine atualizado com gallium-nine para o Padoka e Oibaf
    adicionarPPA2 "deb http://download.virtualbox.org/virtualbox/debian $CODENOME contrib" "virtualbox.list" "virtualbox"
    adicionarPPA2 "deb https://dl.bintray.com/resin-io/debian stable etcher" "etcher.list" "etcher"
    adicionarPPA "ppa:varlesh-l/indicator-kdeconnect" "kdeconnect"
}

function aceitarEulas() {
    aceitarEula "oracle-java8-installer" "shared/accepted-oracle-license-v1-1" "select" "true"
    aceitarEula "ttf-mscorefonts-installer" "msttcorefonts/accepted-mscorefonts-eula" "select" "true"
    aceitarEula "steam" "steam/purge" "note" " "
    aceitarEula "steam" "steam/license" "note" " "
    aceitarEula "steam" "steam/question" "select" "I AGREE"
}

function instalarDebs() {
    instalarDeb "google-chrome-stable" "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
    instalarDeb "hamachi" "https://www.vpn.net/installers/logmein-hamachi_2.1.0.174-1_amd64.deb" # Verificar por updates
    instalarDeb "teamviewer" "http://download.teamviewer.com/download/teamviewer_i386.deb"
    instalarDeb "skypeforlinux" "https://repo.skype.com/latest/skypeforlinux-64-alpha.deb"
    instalarDeb "steam" "http://ftp.br.debian.org/debian/pool/non-free/s/steam/steam_1.0.0.54-2_i386.deb" # O Steam do Debian não tem o bug que estraga a automatização das eulas
    instalarDeb "discord" "https://dl.discordapp.net/apps/linux/0.0.1/discord-0.0.1.deb"
    instalarDeb "insync" "https://d2t3ff60b2tol4.cloudfront.net/builds/insync_1.3.14.36131-trusty_amd64.deb" # Verificar por updates
    instalarDeb "stremio" "http://dl.strem.io/stremio_3.6.5_amd64.deb"
    instalarDeb "playonlinux" "https://www.playonlinux.com/script_files/PlayOnLinux/4.2.10/PlayOnLinux_4.2.10.deb"
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
    instalarApt "etcher-electron" "--allow-unauthenticated"
    instalarApt "filezilla"
    instalarApt "gcc-multilib"
    instalarApt "geany"
    instalarApt "geogebra"
    instalarApt "hostapd"
    instalarApt "gimp"
    instalarApt "git"
    instalarApt "git-cola"
    instalarApt "g++-multilib"
    instalarApt "gparted"
    instalarApt "grub-customizer"
    instalarApt "haguichi"
    instalarApt "hardinfo"
    instalarApt "hplip-gui"
    instalarApt "indicator-kdeconnect"
    instalarApt "jstest-gtk"
    instalarApt "k3b"
    instalarApt "kde-runtime" # Ícones para o Kdenlive 
    instalarApt "kdeconnect"
    instalarApt "kdenlive"
    instalarApt "libavcodec-extra"
    instalarApt "libreoffice"
    instalarApt "mesa-utils"
    instalarApt "mono-complete"
    instalarApt "neofetch"
    instalarApt "openssh-server" # Para o XMouse
    instalarApt "oracle-java8-installer"
    instalarApt "oracle-java8-set-default"
    instalarApt "p7zip-full"
    instalarApt "p7zip-rar"
    instalarApt "ppa-purge"
    instalarApt "qbittorrent"
    instalarApt "qjoypad"
    instalarApt "rar"
    instalarApt "samba"
    instalarApt "simple-scan"
    instalarApt "simplescreenrecorder"
    instalarApt "simplescreenrecorder-lib:i386"
    instalarApt "synaptic"
    instalarApt "telegram"
    instalarApt "tlp"
    instalarApt "tlp-rdw"
    instalarApt "ukuu"
    instalarApt "unrar"
    instalarApt "virtualbox"
    instalarApt "vlc"
    instalarApt "winbind"
    instalarApt "wine2.0"
    instalarApt "winetricks"
    instalarApt "xdotool" # Para o XMouse
    instalarApt "xterm"
}

function instalarCompactado() {
    baixarEExtrair "Create_AP" "zip" "https://codeload.github.com/oblique/create_ap/zip/master"
}








# -----------------------------------------------------------------------------------------------------------

: ' #-------------------------------
    #Depósito de adições desativadas
    #-------------------------------

# CHAVES

    xx

# PPAS
    adicionarPPA "ppa:oibaf/graphics-drivers" "graphics-drivers"
    adicionarPPA "ppa:oibaf/gallium-nine" "gallium-nine" # gallium-nine atualizado para o Oibaf
    # ----------- # Gnome atualizado para o Ubuntu Gnome.
    adicionarPPA "ppa:gnome3-team/gnome3-staging" "ubuntu-gnome3-staging"
    adicionarPPA "ppa:gnome3-team/gnome3" "ubuntu-gnome3"
    # -----------
    adicionarPPA "ppa:ubuntu-wine/ppa" "ubuntu-wine" # Wine atualizado versão estável. Não usar junto com o Wine do gallium-nine.
    adicionarPPA "ppa:dolphin-emu/ppa" "dolphin-emu"
    adicionarPPA "ppa:wine/wine-builds" "wine-builds" # Wine git. Não usar junto com o Wine do gallium-nine.
    adicionarPPA "ppa:webupd8team/y-ppa-manager" "y-ppa-manager"
    adicionarPPA "ppa:teejee2008/ppa" "teejee2008"

#EULAS
    
    xx

# DEBS POR DOWNLOAD NORMAL

    instalarDeb "snes9x-gtk" "https://launchpad.net/ubuntu/+source/snes9x/1:1.52-1/+build/1687493/+files/snes9x-gtk_1.52-1_amd64.deb" # Essa versão tem o 
    instalarDeb "spotifywebplayer" "https://github.com/Quacky2200/Spotify-Web-Player-for-Linux/releases/download/0.9.5-1/spotifywebplayerv0.9.5-1-alpha-x64.deb"
    instalarDeb "dropbox" "https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_2015.10.28_amd64.deb"

# DEBS POR APT-GET

    instalarApt "aptitude"
    instalarApt "breeze-cursor-theme" # Bonito
    instalarApt "dolphin-emu-master" #Emulador
    instalarApt "dolphin-plugins" #Para o gerenciador de arquivos dolphin
    instalarApt "fceux"
    instalarApt "furiusisomount"
    instalarApt "kdesudo"
    instalarApt "mupen64plus-qt"
    instalarApt "nautilus-dropbox" # Esse download do Dropbox funciona muito bem no Nautilus
    instalarApt "okular"
    instalarApt "xscreensaver"
    instalarApt "xscreensaver-gl-extra"
    instalarApt "xscreensaver-data-extra"
    instalarApt "wine-staging" "--install-recommends"
    instalarApt "winehq-staging"
    instalarApt "winetricks"
    instalarApt "y-ppa-manager"
'

# Requisitos para compilação do ttyecho (caso seja necessária):
function instalacoesAptTtyecho() { 
    instalarApt "g++-multilib"
    instalarApt "libc6-dev" "" "PATTERN"
}


