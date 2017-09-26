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





# --------------------
# Pacotes de: 24/09/17
# --------------------


function adicionarChaves() {
    adicionarChave2 "https://dl.google.com/linux/linux_signing_key.pub" "Google Chrome" "Google Inc."
    adicionarChave2 "https://www.virtualbox.org/download/oracle_vbox_2016.asc" "VirtualBox" "VirtualBox"
    adicionarChave "hkp://pgp.mit.edu:80" "379CE192D401AB61" "Etcher" "Bintray (by JFrog)"
    adicionarChave "keyserver.ubuntu.com" "ACCAF35C" "Insync" "Insynchq"
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
    adicionarPPA "ppa:varlesh-l/indicator-kdeconnect" "kdeconnect"
    adicionarPPA "ppa:numix/ppa" "numix"
    adicionarPPA "ppa:paulo-miguel-dias/pkppa" "paulo-miguel"
    adicionarPPA "ppa:teejee2008/ppa" "teejee2008" # Kernels atualizados para o Ubuntu
    adicionarPPA "ppa:commendsarnex/winedri3" "winedri3" # Wine atualizado com gallium-nine para o Padoka e Oibaf
    adicionarPPA2 "deb http://download.virtualbox.org/virtualbox/debian $CODENOME contrib" "virtualbox.list" "virtualbox"
    adicionarPPA2 "deb https://dl.bintray.com/resin-io/debian stable etcher" "etcher.list" "etcher"
    adicionarPPA2 "deb http://apt.insynchq.com/ubuntu $CODENOME non-free contrib" "insync.list" "insync" #DISTRIBUICAO só ubuntu, debian e mint (mint está ruim)
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
    instalarDeb "steam" "http://ftp.br.debian.org/debian/pool/non-free/s/steam/steam_1.0.0.54-2_i386.deb" # Esse consegue automatizar as EULAs
    instalarDeb "discord" "https://dl.discordapp.net/apps/linux/0.0.2/discord-0.0.2.deb" # Verificar por updates
    instalarDeb "playonlinux" "https://www.playonlinux.com/script_files/PlayOnLinux/4.2.12/PlayOnLinux_4.2.12.deb" # Verificar por updates
}

function requisitosTtyecho() { 
    instalarApt "g++-multilib"
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
    instalarApt "insync"
    instalarApt "jstest-gtk"
    instalarApt "k3b"
    instalarApt "kde-runtime" # Ícones para o Kdenlive 
    instalarApt "kdeconnect"
    instalarApt "kdenlive"
    instalarApt "libavcodec-extra"
    instalarApt "libreoffice"
    instalarApt "mesa-utils"
    instalarApt "mono-complete"
    instalarApt "numix-gtk-theme"
    instalarApt "numix-icon-theme-circle"
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
    instalarApt "xdotool" # Para o XMouse
    instalarApt "xterm"
}

function instalarAvulso() {
    baixarEPosicionar "Create_AP" "zip" "./Create_AP" "https://codeload.github.com/oblique/create_ap/zip/master"
    baixarEPosicionar "Stremio" "appimage" "./Stremio" "https://dl.strem.io/linux/v4.0.0-beta.29/Stremio+4.0.0-beta.29.appimage" # Verificar por updates
    baixarEPosicionar "wine-mono-4.7.1" "msi" "./.cache/wine" "http://dl.winehq.org/wine/wine-mono/4.7.1/wine-mono-4.7.1.msi" # Verificar por updates
    baixarEPosicionar "wine_gecko-2.47-x86" "msi" "./.cache/wine" "http://dl.winehq.org/wine/wine-gecko/2.47/wine_gecko-2.47-x86.msi" # Verificar por updates
    baixarEPosicionar "winetricks" "" "/usr/bin" "https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks" --ROOT
}






# Backup
# -----------------------------------------------------------------------------------------------------------

: ' #-------------------------------
    #Depósito de adições desativadas
    #-------------------------------

# CHAVES

    adicionarChave2 "https://dl.winehq.org/wine-builds/Release.key" "Wine" "Wine"

# PPAS
    # ----------- Gáficos open-source atualizados pelo Oibaf
    adicionarPPA "ppa:oibaf/graphics-drivers" "graphics-drivers"
    adicionarPPA "ppa:oibaf/gallium-nine" "gallium-nine" # gallium-nine atualizado para o Oibaf
    # ----------- Gáficos open-source atualizados pelo Padoka
    adicionarPPA "ppa:paulo-miguel-dias/mesa" "paulo-miguel-dias"
    # -----------
    adicionarPPA2 "deb https://dl.winehq.org/wine-builds/ubuntu/ $CODENOME main" "wine-builds.list" "wine" # Wine oficial. Não usar junto com o Wine do gallium-nine.
    adicionarPPA "ppa:dolphin-emu/ppa" "dolphin-emu"
    adicionarPPA "ppa:webupd8team/y-ppa-manager" "y-ppa-manager"

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
    instalarApt "kdesudo"
    instalarApt "mupen64plus-qt"
    instalarApt "nautilus-dropbox" # Esse download do Dropbox funciona muito bem no Nautilus
    instalarApt "okular"
    instalarApt "xscreensaver"
    instalarApt "xscreensaver-gl-extra"
    instalarApt "xscreensaver-data-extra"
    instalarApt "winehq-staging" "--install-recommends --allow-unauthenticated"
    instalarApt "winetricks"
    instalarApt "y-ppa-manager"

# PROGRAMAS AVULSOS

    xx
'

