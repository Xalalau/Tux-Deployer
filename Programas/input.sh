#!/bin/bash
#-----------
# ISNTALATOR
#------------------------------------------------------------v1.0---10/06/16
#-----------------------------------------------------Pacotes de:---24/08/16
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
# Um script que serve para instalar a droga toda no Ubuntu (versão deb)!!
# Ele também é capaz de detectar o que já foi feito no sistema e com isso
# evita problemas e perda de tempo.
#
# Licença: GPL v2
# https://github.com/xalalau/Instalator
# Por Xalalau Xubilozo
# __________________________________________________________________________




function input() {
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
        adicionarChave2 https://d2t3ff60b2tol4.cloudfront.net/services@insynchq.com.gpg.key "Insync"
        adicionarChave2 https://dl.google.com/linux/linux_signing_key.pub "Google Chrome"
        adicionarChave2 https://www.virtualbox.org/download/oracle_vbox_2016.asc "VirtualBox"
        adicionarChave2 https://content.runescape.com/downloads/ubuntu/runescape.gpg.key "Runescape"
    # PPAS
    elif [ "$2" == "1" ]; then
        adicionarPPA ppa:webupd8team/y-ppa-manager "y-ppa-manager"
        adicionarPPA ppa:atareao/atareao "ubuntu-atareao" #clima
        adicionarPPA ppa:atareao/telegram "telegram" #clima
        adicionarPPA ppa:yannubuntu/boot-repair "boot-repair"
        adicionarPPA ppa:oibaf/graphics-drivers "oibaf"
        #adicionarPPA ppa:ubuntu-wine/ppa "ubuntu-wine"
        adicionarPPA ppa:commendsarnex/winedri3 "winedri3" # Wine sempre atualizado e com gallium-nine ativo
        adicionarPPA ppa:qbittorrent-team/qbittorrent-stable "qbittorrent"
        adicionarPPA ppa:webupd8team/haguichi "haguichi"
        adicionarPPA ppa:nilarimogard/webupd8 "webupd8" #freshplayer vem daqui
        adicionarPPA ppa:maarten-baert/simplescreenrecorder "simplescreenrecorder"
        adicionarPPA ppa:webupd8team/java "java"
        adicionarPPA ppa:gezakovacs/ppa "gezakovacs" #unetbootin
        adicionarPPA ppa:unity8-desktop-session-team/unity8-preview-lxc "unity8"
        adicionarPPA ppa:fingerprint/fingerprint-gui "fingerprint"
        adicionarPPA ppa:ermshiperete/monodevelop "mono"
        adicionarPPA ppa:danielrichter2007/grub-customizer "grub-customizer"
        adicionarPPA ppa:linrunner/tlp "tlp"
        adicionarPPA ppa:vlijm/takeabreak "takeabreak"
        adicionarPPA ppa:kdenlive/kdenlive-stable "kdenlive"
        adicionarPPA ppa:atareao/atareao "atareao" #my-weather-indicator
        adicionarPPA2 "deb http://apt.insynchq.com/ubuntu/ $CODENOME non-free contrib" insync.list "insync"
        adicionarPPA2 "deb http://download.virtualbox.org/virtualbox/debian $CODENOME contrib" virtualbox.list "virtualbox"
        adicionarPPA2 "deb https://content.runescape.com/downloads/ubuntu $CODENOME non-free" runescape.list "runescape"
    #EULAS
    elif [ "$3" == "1" ]; then
        aceitarEula "oracle" Java "oracle-java8-installer" shared/accepted-oracle-license-v1-1
        aceitarEula "wine" Wine "ttf-mscorefonts-installer" msttcorefonts/accepted-mscorefonts-eula
    # DEBS POR DOWNLOAD NORMAL
    elif [ "$4" == "1" ]; then
        instalarDeb "google-chrome-stable" https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
        instalarDeb "hamachi" https://secure.logmein.com/labs/logmein-hamachi_2.1.0.139-1_amd64.deb # Pacote com versão fixa, verificar se há updates manualmente.
        instalarDeb "snes9x-gtk" https://launchpad.net/ubuntu/+source/snes9x/1:1.52-1/+build/1687493/+files/snes9x-gtk_1.52-1_amd64.deb # Essa versão é desbugada na parte de cima do menu.
        instalarDeb "teamviewer" http://download.teamviewer.com/download/teamviewer_i386.deb
        instalarDeb "skypeforlinux" https://repo.skype.com/latest/skypeforlinux-64-alpha.deb
    # DEBS POR APT-GET
    elif [ "$5" == "1" ]; then
        instalarApt axel
        instalarApt audacity
        instalarApt blender
        instalarApt bleachbit
        instalarApt boot-repair
        instalarApt brasero
        instalarApt browser-plugin-freshplayer-pepperflash
        instalarApt build-essential
        instalarApt cheese
        instalarApt cifs-utils
        instalarApt codeblocks
        instalarApt cmake
        instalarApt fceux
        instalarApt filezilla
        instalarApt gcc-multilib
        instalarApt gdebi
        instalarApt geany
        instalarApt gimp
        instalarApt git
        instalarApt git-cola
        instalarApt g++-multilib
        instalarApt gparted
        instalarApt grub-customizer
        instalarApt haguichi
        instalarApt haguichi-indicator
        instalarApt handbrake
        instalarApt hardinfo
        instalarApt hplip-gui
        instalarApt insync
        instalarApt insync-nautilus
        instalarApt jstest-gtk
        instalarApt kdenlive
        instalarApt libavcodec-extra
        instalarApt lxc
        instalarApt mesa-utils
        instalarApt mono-complete
        instalarApt mupen64plus
        instalarApt mupen64plus-qt
        instalarApt my-weather-indicator
        instalarApt nautilus-dropbox
        instalarApt oracle-java8-installer
        instalarApt oracle-java8-set-default
        instalarApt p7zip-full
        instalarApt p7zip-rar
        instalarApt ppa-purge
        instalarApt qbittorrent
        instalarApt qjoypad
        instalarApt rar
        instalarApt runescape-launcher
        instalarApt samba
        instalarApt simple-scan
        instalarApt simplescreenrecorder
        instalarApt simplescreenrecorder-lib:i386
        instalarApt snes9x-gtk
        instalarApt synaptic
        instalarApt steam
        instalarApt takeabreak
        instalarApt tlp
        instalarApt tlp-rdw
        instalarApt ubuntu-restricted-extras
        instalarApt unetbootin
        instalarApt unity-tweak-tool
        instalarApt virtualbox-5.1
        instalarApt vlc
        instalarApt winbind
        instalarApt wine1.9
        instalarApt playonlinux # Deve vir depois do Wine para não instalar um monte de bosta
        instalarApt y-ppa-manager
    fi
}
