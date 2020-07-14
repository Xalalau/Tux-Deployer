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
   #	   qualquer substring igual a "NOME DO PACOTE" seja encontrada na nossa $LISTA.

# DEBS POR APT-GET:
   # instalarApt "NOME DO PACOTE" "PARÂMETROS" --SUBSTRING
   # Ex: instalarApt "build-essential" "--install-recommends --allow-unauthenticated"
   # Ex2: instalarApt "libc6-dev" --SUBSTRING
   # NOTA: --SUBSTRING é opcional. Quando usado força a busca pelo pacote a retornar verdadeira caso
   #	   qualquer substring igual a "NOME DO PACOTE" seja encontrada na nossa $LISTA.

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
	adicionarPPA "ppa:oibaf/graphics-drivers" "oibaf"
	adicionarPPA "ppa:atareao/telegram" "telegram"
	adicionarPPA "ppa:lutris-team/lutris" "lutris"
	adicionarPPA "ppa:kdenlive/kdenlive-stable" "kdenlive"
	adicionarPPA "ppa:qbittorrent-team/qbittorrent-stable" "qbittorrent"
	adicionarPPA "ppa:webupd8team/haguichi" "haguichi"
	adicionarPPA "ppa:nilarimogard/webupd8" "webupd8" #freshplayer vem daqui
	adicionarPPA "ppa:maarten-baert/simplescreenrecorder" "simplescreenrecorder"
	adicionarPPA "ppa:linuxuprising/java" "java"
	adicionarPPA "ppa:linrunner/tlp" "tlp"
	adicionarPPA "ppa:dawidd0811/neofetch" "neofetch"
	adicionarPPA "ppa:stebbins/handbrake-releases" "handbrake"
	adicionarPPA "ppa:teejee2008/ppa" "teejee2008" # Kernels atualizados para o Ubuntu
	adicionarPPA2 "deb http://download.virtualbox.org/virtualbox/debian $CODENOME contrib" "virtualbox.list" "virtualbox"
	adicionarPPA2 "deb http://apt.insync.io/ubuntu $CODENOME non-free contrib" "insync.list" "insync" #DISTRIBUICAO só ubuntu, debian e mint
	adicionarPPA2 "deb https://dl.winehq.org/wine-builds/ubuntu/ $CODENOME main" "wine-builds.list" "wine" # Wine oficial. Não usar junto com o Wine do gallium-nine.
}

function aceitarEulas() {
	aceitarEula "oracle-java14-installer" "shared/accepted-oracle-license-v1-1" "select" "true"
	aceitarEula "ttf-mscorefonts-installer" "msttcorefonts/accepted-mscorefonts-eula" "select" "true"
	aceitarEula "steam" "steam/purge" "note" " "
	aceitarEula "steam" "steam/license" "note" " "
	aceitarEula "steam" "steam/question" "select" "I AGREE"
}

function instalarDebs() {
	instalarDeb "code" "https://go.microsoft.com/fwlink/?LinkID=760868"
	instalarDeb "discord" "https://discord.com/api/download?platform=linux&format=deb"
	instalarDeb "google-chrome-stable" "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
	instalarDeb "hamachi" "https://www.vpn.net/installers/logmein-hamachi_2.1.0.203-1_amd64.deb" # Verificar por updates
	instalarDeb "steam" "http://ftp.br.debian.org/debian/pool/non-free/s/steam/steam_1.0.0.54-2_i386.deb" # Esse consegue automatizar as EULAs
	instalarDeb "stremio" "https://dl.strem.io/shell-linux/v4.4.116/stremio_4.4.116-1_amd64.deb" # Verificar por updates
	instalarDeb "teamviewer" "https://download.teamviewer.com/download/linux/teamviewer_amd64.deb"
	instalarDeb "github-desktop" "https://github.com/shiftkey/desktop/releases/download/release-2.5.3-linux1/GitHubDesktop-linux-2.5.3-linux1.deb"
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
	instalarApt "breeze-cursor-theme"
	instalarApt "browser-plugin-freshplayer-pepperflash"
	instalarApt "build-essential"
	instalarApt "cifs-utils" # Para o Samba
	instalarApt "dropbox"
	instalarApt "filezilla"
	instalarApt "geany"
	instalarApt "geogebra"
	instalarApt "g++-9"
	instalarApt "g++-9-multilib"
	instalarApt "gcc-9"
	instalarApt "gcc-9-multilib"
	instalarApt "gimp"
	instalarApt "git"
	instalarApt "gparted"
	instalarApt "grub-customizer"
	instalarApt "haguichi"
	instalarApt "hardinfo"
	instalarApt "handbrake-gtk"
	instalarApt "hostapd"
	instalarApt "hplip-gui"
	instalarApt "insync"
	instalarApt "jstest-gtk"
	instalarApt "k3b"
	instalarApt "libreoffice"
	instalarApt "lutris"
	instalarApt "mesa-utils"
	instalarApt "mono-complete"
	instalarApt "nemo-dropbox"
	instalarApt "neofetch"
	instalarApt "okular"
	instalarApt "oracle-java14-installer"
	instalarApt "oracle-java14-set-default"
	instalarApt "p7zip-full"
	instalarApt "p7zip-rar"
	instalarApt "ppa-purge"
	instalarApt "qbittorrent"
	instalarApt "qdirstat"
	instalarApt "qjoypad"
	instalarApt "samba"
	instalarApt "simple-scan"
	instalarApt "simplescreenrecorder"
	instalarApt "telegram-desktop"
	instalarApt "tlp"
	instalarApt "tlp-rdw"
	instalarApt "virtualbox"
	instalarApt "vlc"
	instalarApt "winbind"
	instalarApt "winehq-stable" "--install-recommends"
	instalarApt "xterm"
}

function instalarAvulsos() {
	baixarEPosicionar "Create_AP" "zip" "~/Applications/Create_AP" "https://codeload.github.com/oblique/create_ap/zip/master"
	baixarEPosicionar "Etcher" "zip" "~/Applications/Etcher" "https://github.com/balena-io/etcher/releases/download/v1.5.101/balena-etcher-electron-1.5.101-linux-x64.zip" # Verificar por updates
	baixarEPosicionar "wine-mono-4.7.1" "msi" "~/.cache/wine" "http://dl.winehq.org/wine/wine-mono/5.1.0/wine-mono-5.1.0-x86.msi" # Verificar por updates
	baixarEPosicionar "wine_gecko-2.47-x86" "msi" "~/.cache/wine" "http://dl.winehq.org/wine/wine-gecko/2.47.1/wine-gecko-2.47.1-x86.msi" # Verificar por updates
	baixarEPosicionar "winetricks" "" "/usr/bin" "https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks" --ROOT
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

	xx

# PPAS
	adicionarPPA "ppa:paulo-miguel-dias/pkppa" "paulo-miguel" # Gáficos open-source estáveis atualizados pelo Padoka
	adicionarPPA "ppa:ubuntu-toolchain-r/test" "toolchain" #GCC-7
	adicionarPPA "ppa:oibaf/graphics-drivers" "graphics-drivers" # Gáficos open-source instáveis atualizados pelo Oibaf
	adicionarPPA "ppa:paulo-miguel-dias/mesa" "paulo-miguel-dias" # Gáficos open-source instáveis atualizados pelo Padoka
	adicionarPPA "ppa:commendsarnex/winedri3" "winedri3" # Wine atualizado com gallium-nine para o Padoka e Oibaf
	adicionarPPA "ppa:webupd8team/java" "java"
	adicionarPPA "ppa:dolphin-emu/ppa" "dolphin-emu"
	adicionarPPA "ppa:webupd8team/y-ppa-manager" "y-ppa-manager"
	adicionarPPA "ppa:numix/ppa" "numix"
	adicionarPPA "ppa:webupd8team/indicator-kdeconnect" "kdeconnect"
	adicionarPPA "ppa:danielrichter2007/grub-customizer" "grub-customizer"

#EULAS
	
	xx

# DEBS POR DOWNLOAD NORMAL

	instalarDeb "snes9x-gtk" "https://launchpad.net/ubuntu/+source/snes9x/1:1.52-1/+build/1687493/+files/snes9x-gtk_1.52-1_amd64.deb" # Essa versão tem os menus da parte superior funcionais
	instalarDeb "spotifywebplayer" "https://github.com/Quacky2200/Spotify-Web-Player-for-Linux/releases/download/0.9.5-1/spotifywebplayerv0.9.5-1-alpha-x64.deb"
	instalarDeb "appimagelauncherd" "https://github.com/TheAssassin/AppImageLauncher/releases/download/continuous/appimagelauncher_1.0.3-travis505.git20190211.5791c72.bionic_amd64.deb" # Integrar appimages em bin, downloads etc.
	instalarDeb "playonlinux" "https://www.playonlinux.com/script_files/PlayOnLinux/4.2.12/PlayOnLinux_4.2.12.deb" # Verificar por updates
    instalarDeb "skype" "https://repo.skype.com/latest/skypeforlinux-64.deb"

# DEBS POR APT-GET

	instalarApt "aptitude"
	instalarApt "bleachbit"
	instalarApt "cheese"
	instalarApt "dolphin-emu-master" #Emulador
	instalarApt "dolphin-plugins" #Para o gerenciador de arquivos dolphin
	instalarApt "elementary-icon-theme"
	instalarApt "fceux"
	instalarApt "furiusisomount"
	instalarApt "git-cola"
	instalarApt "gscan2pdf"
	instalarApt "indicator-kdeconnect"
	instalarApt "kdeconnect"
	instalarApt "kdesudo"
	instalarApt "mupen64plus-qt"
	instalarApt "nautilus-dropbox" # Esse download do Dropbox funciona muito bem no Nautilus
	instalarApt "numix-gtk-theme"
	instalarApt "numix-icon-theme-circle"
	instalarApt "openssh-server" # Para o XMouse
	instalarApt "pdfshuffler"
	instalarApt "rar"
	instalarApt "simplescreenrecorder-lib:i386"
	instalarApt "synaptic"
	instalarApt "unrar"
	instalarApt "ukuu"
	instalarApt "xdotool" # Para o XMouse
	instalarApt "xscreensaver"
	instalarApt "xscreensaver-gl-extra"
	instalarApt "xscreensaver-data-extra"
	instalarApt "winehq-staging" "--install-recommends --allow-unauthenticated"
	instalarApt "winetricks"
	instalarApt "y-ppa-manager"

# PROGRAMAS AVULSOS

	xx
'

