# !/bin/bash

INSTALADO="[ ✔ ]\n"
ATUALIZADO="[ ⟳ ]\n"
FALHOU="[×××]\n"

function imprimirCabecalho() {
    echo "====================================="
    echo $NOME "-" $VERSAO
    echo "====================================="
    echo $POR", licença:" $LICENCA
    echo $LINK
    echo "====================================="
    echo
}

function definirOpcoes() {
    imprimirCabecalho
    
    echo "❱ Deseja fazer a instalação completa? [S/N] "
    echo 
    echo "Passos:"
    echo "- Liberar repositório de parceiros da Canonical;"
    echo "- Adicionar chaves de repositórios;"
    echo "- Adicionar repositórios;"
    echo "- Atualizar sistema com \"apt update\" e \"apt upgrade\";"
    echo "- Aceitar EULAS;"
    echo "- Baixar e instalar arquivos .deb;"
    echo "- Instalar programas via \"apt install\";"
    echo "- Baixar e extrair programas compactados;"
    echo "- Criar um prefixo 32 bits no Wine (caso necessário)."
    echo ""
    echo "Selecionar \"N\" (Não) implicará na escolha dos passos."
    echo
    echo -n "Escolha: "
    while true; do
        read -r INSTALACAO_PADRAO
        if [ "$INSTALACAO_PADRAO" == "s" ] || [ "$INSTALACAO_PADRAO" == "n" ] || [ "$INSTALACAO_PADRAO" == "S" ] || [ "$INSTALACAO_PADRAO" == "N" ]; then
            break
        fi
    done

    clear

    if [ "$INSTALACAO_PADRAO" == "s" ] || [ "$INSTALACAO_PADRAO" == "S" ]; then
        ADICIONAR_CHAVES="s"
        ADICIONAR_REPOSITORIOS="s"
        PROCESSAR_DEBS="s"
        PROCESSAR_APT="s"
        PROCESSAR_COMPACTADOS="s"
        LIBERAR_PARCEIROS="s"
        ATUALIZAR_PACOTES="s"
        USAR_DIST_UPGRADE="n"
        ACEITAR_EULAS="s"
        PREFIXO_WINE32="s"
    else
        imprimirCabecalho
    
        echo -n "❱ Registrar repositórios? [S/N] "
        while true; do
            read -r ADICIONAR_REPOSITORIOS
            if [ "$ADICIONAR_REPOSITORIOS" == "s" ] || [ "$ADICIONAR_REPOSITORIOS" == "n" ] || [ "$ADICIONAR_REPOSITORIOS" == "S" ] || [ "$ADICIONAR_REPOSITORIOS" == "N" ]; then
                break
            fi
        done

        if [ "$ADICIONAR_REPOSITORIOS" == "s" ] || [ "$ADICIONAR_REPOSITORIOS" == "S" ]; then 
            echo -n "❱ Registrar chaves dos repositórios? [S/N] "
            while true; do
                read -r ADICIONAR_CHAVES
                if [ "$ADICIONAR_CHAVES" == "s" ] || [ "$ADICIONAR_CHAVES" == "n" ] || [ "$ADICIONAR_CHAVES" == "S" ] || [ "$ADICIONAR_CHAVES" == "N" ]; then
                    break
                fi
            done
        fi

        echo -n "❱ Baixar e instalar os arquivos .deb? [S/N] "
        while true; do
            read -r PROCESSAR_DEBS
            if [ "$PROCESSAR_DEBS" == "s" ] || [ "$PROCESSAR_DEBS" == "n" ] || [ "$PROCESSAR_DEBS" == "S" ] || [ "$PROCESSAR_DEBS" == "N" ]; then
                break
            fi
        done

        echo -n "❱ Baixar e instalar os programas por apt? [S/N] "
        while true; do
            read -r PROCESSAR_APT
            if [ "$PROCESSAR_APT" == "s" ] || [ "$PROCESSAR_APT" == "n" ] || [ "$PROCESSAR_APT" == "S" ] || [ "$PROCESSAR_APT" == "N" ]; then
                break
            fi
        done

        echo -n "❱ Baixar e extrair em pastas os programas compactados? [S/N] "
        while true; do
            read -r PROCESSAR_COMPACTADOS
            if [ "$PROCESSAR_COMPACTADOS" == "s" ] || [ "$PROCESSAR_COMPACTADOS" == "n" ] || [ "$PROCESSAR_COMPACTADOS" == "S" ] || [ "$PROCESSAR_COMPACTADOS" == "N" ]; then
                break
            fi
        done

        echo -n "❱ Aceitar EULAS das instalações? [S/N] "
        while true; do
            read -r ACEITAR_EULAS
            if [ "$ACEITAR_EULAS" == "s" ] || [ "$ACEITAR_EULAS" == "n" ] || [ "$ACEITAR_EULAS" == "S" ] || [ "$ACEITAR_EULAS" == "N" ]; then
                break
            fi
        done

        if [ "$(find /etc/apt/ -name *.list | xargs cat | grep  ^[[:space:]]*deb | grep -v deb-src | grep partner)" == "" ]; then
            echo -n "❱ Liberar o repositório de parceiros do Ubuntu? [S/N] "
            while true; do
                read -r LIBERAR_PARCEIROS
                if [ "$LIBERAR_PARCEIROS" == "s" ] || [ "$LIBERAR_PARCEIROS" == "n" ] || [ "$LIBERAR_PARCEIROS" == "S" ] || [ "$LIBERAR_PARCEIROS" == "N" ]; then
                    break
                fi
            done
        fi

        echo -n "❱ Atualizar a listagem de pacotes com \"apt update\"? [S/N] "
        while true; do
            read -r ATUALIZAR_PACOTES
            if [ "$ATUALIZAR_PACOTES" == "s" ] || [ "$ATUALIZAR_PACOTES" == "n" ] || [ "$ATUALIZAR_PACOTES" == "S" ] || [ "$ATUALIZAR_PACOTES" == "N" ]; then
                break
            fi
        done

        if [ "$ATUALIZAR_PACOTES" == "s" ] || [ "$ATUALIZAR_PACOTES" == "S" ]; then
            echo -n "❱ Atualizar pacotes com \"apt dist-upgrade\" ao invés de \"apt upgrade\"? [S/N] "
            while true; do
                read -r USAR_DIST_UPGRADE
                if [ "$USAR_DIST_UPGRADE" == "s" ] || [ "$USAR_DIST_UPGRADE" == "n" ] || [ "$USAR_DIST_UPGRADE" == "S" ] || [ "$USAR_DIST_UPGRADE" == "N" ]; then
                    break
                fi
            done
        fi

        echo -n "❱ Criar um prefixo 32 bits para o Wine (caso seja necessário)? [S/N] "
        while true; do
            read -r PREFIXO_WINE32
            if [ "$PREFIXO_WINE32" == "s" ] || [ "$PREFIXO_WINE32" == "n" ] || [ "$PREFIXO_WINE32" == "S" ] || [ "$PREFIXO_WINE32" == "N" ]; then
                break
            fi
        done
    fi
}

function ativarSudo() {
    # Ativar o sudo
    sudo clear
}

function echo2() {
    # Imprimir texto no terminal secundário
    echo "" &>$CONSOLE;
    echo "$1" &>$CONSOLE;
    echo "--------------------------------------------------------------------------------" &>$CONSOLE;
}

function criarListasDePacotes() {
    # Lista dinâmica onde serão procurados pacotes com exatidão
    LISTA=($(dpkg --get-selections | grep -v deinstall | awk '{print $1}'))
    # Contagem de resultados da lista 1
    while [ ${LISTA[$QUANTPACOTES]} ]; do 
        QUANTPACOTES=$((QUANTPACOTES + 1))
    done
}

function checarPacotePorPattern() {
    # Checa se o nome do pacote está em qualquer lugar na lista
    # Nota: usar só em casos especiais, essa função é muito ruim!
    # $1 = nome do pacote
    # Retorna: 1 [Achou] / 0 [Não achou]
    local i=0
    local resultado=0

    for each in "${LISTA[@]}"; do
        if echo "$each" | grep -q "$1"; then
            resultado=1
            break
        fi
        i=$((i + 1))
    done

    return $resultado
}

function checarPacote() {
    # Algoritmo de busca binária
    # https://en.wikipedia.org/wiki/Binary_search_algorithm
    # $1 = nome do pacote
    # $2 = limite inicial da busca
    # $3 = limite final da busca
    # Retorna: 1 [Achou] / 0 [Não achou]
    if [ "$3" -lt "$2" ]; then
        return 0
    else
        local var3=$2
        local var4=$3
        local imid=$(((var3+var4)/2))
        if [ "${LISTA[$imid]}" \> "$1" ]; then
            checarPacote $1 $2 $((imid - 1))
        elif [ "${LISTA[$imid]}" \< "$1" ]; then
            checarPacote $1 $((imid + 1)) $3
        else
            return 1
        fi
    fi
    return $?
}

function checarComando() {
    # $1 comando
    # Retorna: 1 [Achou] / 0 [Não achou]
    type $1 >/dev/null 2>&1 && { 
        return 1
    } || {
        return 0
    }
}

function checarExistenciaPacoteOuComando() {
    # $1 = nome do pacote
    # Retorna: 1 [Achou] / 0 [Não achou]
    checarComando $1
    if [ "$?" -eq "1" ]; then
        return 1
    fi
    checarPacote $1 0 $QUANTPACOTES
    if [ "$?" -eq "1" ]; then
        return 1
    fi
    return 0
}

function apt-get_update() {
    echo2 "apt-get update"
    sudo apt-get update &>$CONSOLE;
}

function apt-get_dist-upgrade() {
    echo2 "apt-get dist-upgrade"
    sudo apt-get dist-upgrade -y &>$CONSOLE;
}

function apt-get_upgrade() {
    echo2 "apt-get upgrade"
    sudo apt-get upgrade -y &>$CONSOLE;
}

function apt-get_autoremove() {
    echo2 "apt-get autoremove"
    sudo apt-get autoremove -y &>$CONSOLE;
}

function gerarTerminalSecundario() {
    # Criar terminal extra
    cd "../external/"
    if ! [ -f console.txt ]; then
        ./newterm.sh "tty" ">" "console.txt"
        sleep 1.2
        CONSOLE=$(cat console.txt)
    else
        CONSOLE=$(cat console.txt)
        if ! echo >& $CONSOLE; then
            ./newterm.sh "tty" ">" "console.txt"
            sleep 1.2
            CONSOLE=$(cat console.txt)
        fi
    fi
    cd "$DIR_BASE"
    echo "" >& $CONSOLE
}

function compilarTtyecho() {
    # Compilar "ttyecho" - programa que executa comandos em outro terminal
    local requisitos=0
    checarComando "gcc"
    if [ "$?" -eq "0" ]; then
        requisitos=1
    else
        criarListasDePacotes
        checarPacotePorPattern "libc6-dev"
        if [ "$?" -eq "0" ]; then
           requisitos=1
        fi
    fi
    if [ "$requisitos" -eq "1" ]; then
        echo "\n❱ Instalando requisitos:"
        instalacoesAptTtyecho
        echo -n "❱ Copiando programa para o \"/usr/bin\"..."
    fi
    echo2 "gcc ttyecho.c -o ttyecho"
    gcc ttyecho.c -o ttyecho >& $CONSOLE;
}

function instalarTtyecho() {
    # Instalar "ttyecho" - programa que executa comandos em outro terminal
    command -v ttyecho >/dev/null 2>&1 || {
        echo -n "❱ Instalando \"ttyecho\" para gerir o terminal secundário..."
        cd "../external/"
        if ! [[ -f ttyecho ]]; then
            compilarTtyecho
        fi
        echo2 "sudo cp ttyecho \"/usr/bin\""
        sudo cp ttyecho "/usr/bin" >& $CONSOLE;
        echo " Pronto."
        cd "$DIR_BASE"
    }
}

function adicionarPPA() {
    # $1 = PPA
    # $2 = termo usado para checar se esse PPA já existe
    if ! grep -q "$2" /etc/apt/sources.list /etc/apt/sources.list.d/* >/dev/null 2>&1; then # O Grep olha dentro dos arquivos
        if [ "$AUX_PRINT" -eq "1" ];then
            echo "❱ Adicionando repositórios..."
            AUX_PRINT=0
            LIB=1
        fi
        echo2 "sudo add-apt-repository "$1" -y"
        sudo add-apt-repository "$1" -y &>$CONSOLE;
    fi
}

function adicionarPPA2() {
    # $1 = PPA
    # $2 = arquivo aonde ficará o PPA
    # $3 = termo para impressão
    if [ ! -f "/etc/apt/sources.list.d/$2" ]; then
        if [ "$AUX_PRINT" -eq "1" ];then
            echo "❱ Adicionando repositórios..."
            AUX_PRINT=0
            LIB=1
        fi
        echo2 "\"$1\" >> \"$2\" && sudo mv \"$2\" \"/etc/apt/sources.list.d/\""
        echo "$1" >> "$2"
        sudo mv "$2" "/etc/apt/sources.list.d/"
    fi
}

function adicionarChave() {
    # $1 = servidor da chave
    # $2 = chave
    # $3 = termo para impressão
    # $4 = termo para pesquisar se a chave já foi adicionada
    if ! apt-key list | grep -q "$4"; then
        if [ "$AUX_PRINT" -eq "1" ];then
            echo "❱ Adicionando chaves..."
            AUX_PRINT=0
            LIB=1
        fi
        echo2 "sudo apt-key adv --keyserver \"$1\" --recv-keys \"$2\""
        sudo apt-key adv --keyserver "$1" --recv-keys "$2" &>$CONSOLE;
    fi
}

function adicionarChave2() {
    # $1 = download da chave
    # $2 = termo para impressão
    # $3 = termo para pesquisar se a chave já foi adicionada
    if ! apt-key list | grep -q "$3"; then
        if [ "$AUX_PRINT" -eq "1" ];then
            echo "❱ Adicionando chaves..."
            AUX_PRINT=0
            LIB=1
        fi
        echo2 "wget -qO - $1 | sudo apt-key add -"
        wget -qO - $1 | sudo apt-key add - &>$CONSOLE;
    fi
}

function liberarRepositorioParceirosCanonical() {
    if [ "$(find /etc/apt/ -name *.list | xargs cat | grep  ^[[:space:]]*deb | grep -v deb-src | grep partner)" == "" ]; then
        echo2 "sudo sed -i \"/^# deb .*partner/ s/^# //\" /etc/apt/sources.list"
        sudo sed -i "/^# deb .*partner/ s/^# //" /etc/apt/sources.list &>$CONSOLE;
        LIB=1
    fi
}

function aceitarEula() {
    # $1 = nome do pacote que requer a automatização
    # $2 = seção de eula que será marcada
    # $3 = item de seção a ser configurado
    # $4 = valor do item de seção
    if [ "$(sudo debconf-show $1 | grep $2)" == "" ]; then
        echo "❱ Automatizando instalação de \"$1\"..."
        echo2 "echo $1 $2 $3 $4 | sudo debconf-set-selections"
        echo $1 $2 $3 $4 | sudo debconf-set-selections
        LIB=1
    fi
}

function instalarApt() {
    # $1 = pacote a ser instalado via apt-get
    # $2 = algum parâmetro qualquer
    # $3 = "PATTERN" = a busca pelo pacote será feita na função checarPacotePorPattern()
    local juntar=$1
    juntar+=" "
    juntar+=$2
    printf "❱ %-50s" "$juntar"
    if [ "$3" != "PATTERN" ]; then
        checarExistenciaPacoteOuComando $1
    else
        checarPacotePorPattern $1
    fi
    local res=$?
    if [ "$res" -eq "1" ]; then
        printf "$INSTALADO"
    else
        echo2 "Instalando \"$1\"..."
        sudo apt-get install $1 $2 -y &>$CONSOLE;
        dpkg -s "$1" &>$CONSOLE;
        if [ "$3" != "PATTERN" ]; then
            criarListasDePacotes
            checarExistenciaPacoteOuComando $1
        else
            checarPacotePorPattern $1
        fi
        res=$?
        if [ "$res" -eq "0" ]; then
            printf "$FALHOU"
        else
            printf "$ATUALIZADO"
        fi
    fi
}

function instalarDeb() {
    # $1 = nome do pacote
    # $2 = link de download
    # $3 = "PATTERN" = a busca pelo pacote será feita na função checarPacotePorPattern()
    if [ "$3" != "PATTERN" ]; then
        checarExistenciaPacoteOuComando $1
    else
        checarPacotePorPattern $1
    fi
    local res=$?
    printf "❱ %-50s" $1
    if [ "$res" -eq "1" ]; then
        printf "$INSTALADO"
    else
        local nome="${1}.deb"
        echo2 "Instalando \"$1\"..."
        wget -O $nome $2 &>$CONSOLE;
        sudo dpkg -i *.deb &>$CONSOLE;
        sudo apt-get -f install -y &>$CONSOLE;
        if [ "$3" != "PATTERN" ]; then
            criarListasDePacotes
            checarExistenciaPacoteOuComando $1
        else
            checarPacotePorPattern $1
        fi
        if [ "$?" -eq "0" ]; then
            printf "$FALHOU"
        else
            printf "$ATUALIZADO"
        fi
        rm *.deb &>$CONSOLE;
    fi
}

function baixarEExtrair() {
    # $1 = nome da pasta onde iremos extrair o pacote
    # $1 = extensão do pacote (zip, rar ou tar.gz)
    # $2 = link de download
    printf "❱ %-50s" "$1"
    check=~/$1
    if test -d "$check"
    then
        printf "$INSTALADO"
    else
        echo2 "Baixando e extraindo \"$1\"..."
        cd ~/
        mkdir "$1" &>$CONSOLE;
        cd "$1"
        wget $3 -O "$1.$2" &>$CONSOLE;
        if [ "$2" == "zip" ]; then
            unzip ./*.zip &>$CONSOLE;
            rm ./*.zip &>$CONSOLE;
        elif [ "$2" == "rar" ]; then
            unrar ./*.rar &>$CONSOLE;
            rm ./*.rar &>$CONSOLE;
        elif [ "$2" == "tar.gz" ]; then
            tar -zxvf ./*.tar.gz &>$CONSOLE;
            rm ./*.tar.gz &>$CONSOLE;
        fi
        quant=$(find . -mindepth 1 -maxdepth 1 -type d | wc -l)
        if [ $quant -eq 0 ]; then
            printf "$FALHOU"
            cd ~/
            rm -r "$1"
            return
        elif [ $quant -eq 1 ]; then
            dir=$(find . -mindepth 1 -maxdepth 1 -type d)
            mv $dir/* ./ &>$CONSOLE;
            rm -r $dir &>$CONSOLE;
        fi
        cd "$DIR_BASE"
        printf "$ATUALIZADO"
    fi
}

function iniciarTlp() {
    checarExistenciaPacoteOuComando "tlp"
    RES=$?
    if [ "$RES" -ne "0" ]; then
        if [[ $(sudo service tlp status) != *"active (exited)"* ]]; then
            echo "❱ Iniciando TLP..."
            echo2 "sudo tlp start && service tlp start"
            sudo tlp start &>$CONSOLE;
            sudo service tlp start &>$CONSOLE;
        fi
    fi
}

function criarPrefixoWine32Bits() {
    checarExistenciaPacoteOuComando "wine"
    RES=$?
    if [ "$RES" -ne "0" ]; then
        if [ ! -d "$HOME/.wine" ]; then
            echo "❱ Criando prefixo padrão de 32bits para o Wine"
            echo2 "WINEPREFIX=$HOME/.wine WINEARCH='win32' wine 'wineboot'"
            WINEPREFIX=$HOME/.wine WINEARCH='win32' wine 'wineboot' &>$CONSOLE;
            echo
        fi
    fi
}

function removerTerminalSecundario() {
    echo "❱ Removendo terminal secundário..."
    if [ -f "../external/console.txt" ]; then
        rm ../external/console.txt
    fi
    sudo ttyecho -n $CONSOLE exit
}

function finalizar() {
    read -p "❱ Tudo pronto! Aperte \"Enter\" para finalizar."
    echo
    removerTerminalSecundario
}

