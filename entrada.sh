
function entrada() {
    # Entrar com 0/1 nos parâmetros para ignorar/ativar cada seção:
    # $1 = chaves
    # $2 = ppas
    # $3 = eulas
    # $4 = debs por download na internet
    # $5 = debs por apt-get    
    # Ex: input(0, 1, 0, 0, 0) // Ativa a adição de ppas

    # Funcionamento CHAVES:
      # adicionarChave SERVIDOR CHAVE "RÓTULO QUALQUER"
      # EX: adicionarChave pgp.mit.edu 5044912E "Dropbox"
      # adicionarChave2 LINK_DOWNLOAD_CHAVE "RÓTULO QUALQUER"
      # EX: adicionarChave2 https://d2t3ff60b2tol4.cloudfront.net/services@insynchq.com.gpg.key "Insync" 
   # Funcionamento PPAS:
      # adicionarPPA PPA "TERMO QUE PODE IDENTIFICÁ-LO EM /etc/apt/sources.list.d/*"
      # Ex: adicionarPPA ppa:webupd8team/y-ppa-manager "y-ppa-manager"
      # adicionarPPA2 "COMANDO DEB DE ADIÇÃO DE REPOSITÓRIOS" NOME_DO_ARQUIVO.list "RÓTULO QUALQUER"
      # Ex: adicionarPPA2 "deb http://linux.dropbox.com/ubuntu/ $CODENOME main" dropbox.list "dropbox"
    # Funcionamento EULAS:
      # Deve-se por o pacote no IF (verificar se já está instalado) e então automatizar a aceitação da eula
    # Funcionamento DEBS POR DOWNLOAD:
      # baixarDeb "NOME DO PACOTE" LINK
      # Ex: baixarDeb "steam-launcher" https://steamcdn-a.akamaihd.net/client/installer/steam.deb
    # Funcionamento DEBS POR APT-GET:
      # instalarApt "NOME DO PACOTE"
      # Ex: instalarApt build-essential

    # CHAVES
    if [ "$1" == "1" ]; then
        #adicionarChave2 https://d2t3ff60b2tol4.cloudfront.net/services@insynchq.com.gpg.key "Insync"
        adicionarChave2 https://dl.google.com/linux/linux_signing_key.pub "Google Chrome"
        #adicionarChave2 https://www.virtualbox.org/download/oracle_vbox_2016.asc "VirtualBox"
    # PPAS
    elif [ "$2" == "1" ]; then
        adicionarPPA ppa:atareao/telegram "telegram"
        #adicionarPPA ppa:oibaf/graphics-drivers "graphics-drivers"
        #adicionarPPA ppa:oibaf/gallium-nine "gallium-nine" # Não pode ser usado com o ppa:paulo-miguel-dias/mesa!!
        adicionarPPA ppa:paulo-miguel-dias/mesa "paulo-miguel-dias"
        #adicionarPPA ppa:ubuntu-wine/ppa "ubuntu-wine"
        adicionarPPA ppa:commendsarnex/winedri3 "winedri3" # Wine sempre atualizado e com gallium-nine ativo
        adicionarPPA ppa:qbittorrent-team/qbittorrent-stable "qbittorrent"
        adicionarPPA ppa:webupd8team/haguichi "haguichi"
        adicionarPPA ppa:nilarimogard/webupd8 "webupd8" #freshplayer vem daqui
        adicionarPPA ppa:maarten-baert/simplescreenrecorder "simplescreenrecorder"
        adicionarPPA ppa:webupd8team/java "java"
        adicionarPPA ppa:danielrichter2007/grub-customizer "grub-customizer"
        adicionarPPA ppa:ermshiperete/monodevelop "mono"
        adicionarPPA ppa:linrunner/tlp "tlp"
        adicionarPPA ppa:kdenlive/kdenlive-stable "kdenlive"
        adicionarPPA ppa:gnome3-team/gnome3-staging "ubuntu-gnome3-staging"
        adicionarPPA ppa:gnome3-team/gnome3 "ubuntu-gnome3"
        #adicionarPPA2 "deb http://apt.insynchq.com/ubuntu/ $CODENOME non-free contrib" insync.list "insync"
        #adicionarPPA2 "deb http://download.virtualbox.org/virtualbox/debian $CODENOME contrib" virtualbox.list "virtualbox"
    #EULAS
    elif [ "$3" == "1" ]; then
        aceitarEula oracle "oracle-java8-installer" shared/accepted-oracle-license-v1-1 "select" true
        aceitarEula wine "ttf-mscorefonts-installer" msttcorefonts/accepted-mscorefonts-eula "select" true
        aceitarEula steam "steam/license" note " "
        aceitarEula steam "steam/question" select "I AGREE"
    # DEBS POR DOWNLOAD NORMAL
    elif [ "$4" == "1" ]; then
        instalarDeb "google-chrome-stable" https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
        instalarDeb "hamachi" https://secure.logmein.com/labs/logmein-hamachi_2.1.0.139-1_amd64.deb # Pacote com versão fixa, verificar se há updates manualmente.
        instalarDeb "snes9x-gtk" https://launchpad.net/ubuntu/+source/snes9x/1:1.52-1/+build/1687493/+files/snes9x-gtk_1.52-1_amd64.deb # Essa versão é desbugada na parte de cima do menu.
        instalarDeb "teamviewer" http://download.teamviewer.com/download/teamviewer_i386.deb
        instalarDeb "skypeforlinux" https://repo.skype.com/latest/skypeforlinux-64-alpha.deb
        instalarDeb "spotifywebplayer" https://github.com/Quacky2200/Spotify-Web-Player-for-Linux/releases/download/0.9.5-1/spotifywebplayerv0.9.5-1-alpha-x64.deb
    # DEBS POR APT-GET
    elif [ "$5" == "1" ]; then
        instalarApt axel
        instalarApt audacity
        instalarApt blender
        instalarApt bleachbit
        instalarApt brasero
        instalarApt breeze-cursor-theme
        instalarApt browser-plugin-freshplayer-pepperflash
        instalarApt build-essential
        instalarApt cheese
        instalarApt cifs-utils # Para o Samba
        instalarApt fceux
        instalarApt filezilla
        instalarApt gcc-multilib
        instalarApt geany
        instalarApt gimp
        instalarApt git
        instalarApt git-cola
        instalarApt g++-multilib
        instalarApt gparted
        instalarApt haguichi
        instalarApt hardinfo
        instalarApt hplip-gui
        #instalarApt insync-nautilus
        instalarApt jstest-gtk
        instalarApt kdenlive
        instalarApt kde-runtime # Ícones para o Kdenlive
        instalarApt libavcodec-extra
        instalarApt libreoffice
        instalarApt mesa-utils
        instalarApt mono-complete
        instalarApt mupen64plus-qt
        instalarApt nautilus-dropbox
        instalarApt openssh-server # Para o XMouse
        instalarApt oracle-java8-installer
        instalarApt oracle-java8-set-default
        instalarApt p7zip-full
        instalarApt p7zip-rar
        instalarApt ppa-purge
        instalarApt qbittorrent
        instalarApt qjoypad
        instalarApt rar
        instalarApt samba
        instalarApt simple-scan
        instalarApt simplescreenrecorder
        instalarApt simplescreenrecorder-lib:i386
        instalarApt synaptic
        instalarApt steam
        instalarApt telegram
        instalarApt tlp
        instalarApt tlp-rdw
        #instalarApt ubuntu-restricted-extras
        #instalarApt virtualbox-5.1
        instalarApt vlc
        instalarApt xdotool # Para o XMouse
        instalarApt winbind
        instalarApt wine1.9
        instalarApt playonlinux # Deve vir depois do Wine para não instalar um monte de bosta
    fi
}

