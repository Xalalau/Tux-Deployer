# Funcionamento das chamadas de função:

# CHAVES:
   # adicionarChave "SERVIDOR" "CHAVE" "RÓTULO QUALQUER"
   # EX: adicionarChave "pgp.mit.edu" "5044912E" "Dropbox"
   # adicionarChave2 "LINK_DOWNLOAD_CHAVE" "RÓTULO QUALQUER"
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
   # baixarDeb "NOME DO PACOTE" "LINK"
   # Ex: baixarDeb "steam-launcher" "https://steamcdn-a.akamaihd.net/client/installer/steam.deb"

# DEBS POR APT-GET:
   # instalarApt "NOME DO PACOTE" "ALGUM PARAMETRO"
   # Ex: instalarApt "build-essential" "--install-recommends"




function adicionarChaves() {
    adicionarChave2 "https://dl.google.com/linux/linux_signing_key.pub" "Google Chrome"
    adicionarChave2 "https://www.virtualbox.org/download/oracle_vbox_2016.asc" "VirtualBox"
}

function adicionarPPAs() {
    adicionarPPA "ppa:wine/wine-builds" "wine-builds" # Wine git
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
    adicionarPPA2 "deb http://download.virtualbox.org/virtualbox/debian $CODENOME contrib" "virtualbox.list" "virtualbox"
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
    instalarDeb "hamachi" "https://secure.logmein.com/labs/logmein-hamachi_2.1.0.139-1_amd64.deb" # Pacote com versão fixa! Verificar se há updates manualmente e atualizar o link de download.
    instalarDeb "teamviewer" "http://download.teamviewer.com/download/teamviewer_i386.deb"
    instalarDeb "skypeforlinux" "https://repo.skype.com/latest/skypeforlinux-64-alpha.deb"
    instalarDeb "steam" "http://ftp.us.debian.org/debian/pool/non-free/s/steam/steam_1.0.0.54-1_i386.deb" # O Steam do Debian não tem o bug que estraga a automatização das eulas
    instalarDeb "discord-canary" "https://discordapp.com/api/download/canary?platform=linux" # https://github.com/crmarsh/discord-linux-bugs
}

function instalacoesApt() {
    instalarApt "axel"
    instalarApt "audacity"
    instalarApt "blender"
    instalarApt "bleachbit"
    instalarApt "browser-plugin-freshplayer-pepperflash"
    instalarApt "build-essential"
    instalarApt "cheese"
    instalarApt "dolphin-plugins" #Para o gerenciador de arquivos dolphin
    instalarApt "filezilla"
    instalarApt "gcc-multilib"
    instalarApt "geany"
    instalarApt "geogebra"
    instalarApt "gimp"
    instalarApt "git"
    instalarApt "git-cola"
    instalarApt "g++-multilib"
    instalarApt "gparted"
    instalarApt "grub-customizer"
    instalarApt "haguichi"
    instalarApt "hardinfo"
    instalarApt "hplip-gui"
    instalarApt "jstest-gtk"
    instalarApt "k3b"
    instalarApt "kdenlive"
    instalarApt "libavcodec-extra"
    instalarApt "libreoffice"
    instalarApt "mesa-utils"
    instalarApt "mono-complete"
    instalarApt "okular"
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
    instalarApt "telegram"
    instalarApt "tlp"
    instalarApt "tlp-rdw"
    instalarApt "virtualbox-5.1"
    instalarApt "vlc"
    instalarApt "winbind"
    instalarApt "wine-staging" "--install-recommends"
    instalarApt "winehq-staging"
    instalarApt "playonlinux" # Deve ser instalado depois do Wine para não cagar um Wine 1.6 no sistema
}














: ' #-------------------------------
    #Depósito de adições desativadas
    #-------------------------------

    # CHAVES

        xx

    # PPAS

        # -----------
        # O Padoka e o Oibaf entregam gráficos open-source de ponta mas podem acabar com o sistema. Caso eles tragam problemas ou a imagem suma, só será
        # possível removê-los pelo terminal se conectando com a internet pelo wpa_supplicant e desinstalando os ppas com o ppa-purge (primeiro o de Wine
        # e depois o principal). Algo que pode causar bugs complicados é misturá-los. Eles devem ser utilizados separadamente. Caso haja intenção de
        # alterná-los, o que está no sistema deverá ser limpo com ppa-purge antes de começar a instação do novo.
        adicionarPPA "ppa:oibaf/graphics-drivers" "graphics-drivers"
        adicionarPPA "ppa:oibaf/gallium-nine" "gallium-nine" # Wine atualizado com gallium-nine para o Oibaf
        adicionarPPA "ppa:paulo-miguel-dias/mesa" "paulo-miguel-dias"
        adicionarPPA "ppa:commendsarnex/winedri3" "winedri3" # Wine atualizado com gallium-nine para o Padoka
        # -----------
        # Esses ppas trazem o gnome de ponta ao Ubuntu. Já os testei no Ubuntu Gnome e os resultados foram muito bons.
        adicionarPPA "ppa:gnome3-team/gnome3-staging" "ubuntu-gnome3-staging"
        adicionarPPA "ppa:gnome3-team/gnome3" "ubuntu-gnome3"
        adicionarPPA "ppa:dolphin-emu/ppa" "dolphin-emu"
        # -----------
        adicionarPPA "ppa:ubuntu-wine/ppa" "ubuntu-wine" # Wine atualizado versão estável

    #EULAS
    
        xx
    
    # DEBS POR DOWNLOAD NORMAL

        instalarDeb "snes9x-gtk" "https://launchpad.net/ubuntu/+source/snes9x/1:1.52-1/+build/1687493/+files/snes9x-gtk_1.52-1_amd64.deb" # Essa versão tem o 
        instalarDeb "spotifywebplayer" "https://github.com/Quacky2200/Spotify-Web-Player-for-Linux/releases/download/0.9.5-1/spotifywebplayerv0.9.5-1-alpha-x64.deb"

    # DEBS POR APT-GET

        instalarApt "breeze-cursor-theme" # Bonito
        instalarApt "dolphin-emu-master" #Emulador
        instalarApt "cifs-utils" # Para o Samba
        instalarApt "fceux"
        instalarApt "kde-runtime" # Ícones para o Kdenlive
        instalarApt "mupen64plus-qt"
        instalarApt "nautilus-dropbox"# Esse download do Dropbox funciona muito bem no Nautilus
        instalarApt "openssh-server" # Para o XMouse
        instalarApt "synaptic"
        instalarApt "xdotool" # Para o XMouse
        instalarApt "xscreensaver"
        instalarApt "xscreensaver-gl-extra"
        instalarApt "xscreensaver-data-extra"
'
