# !/bin/bash

function printarCabecalho() {
    echo "====================================="
    echo $NOME "-" $VERSAO
    echo "====================================="
    echo $POR", licença:" $LICENCA
    echo $LINK
    echo "====================================="
    echo
}

function definirOpcoes() {
    printarCabecalho
    
    echo "[SCRIPT] Deseja fazer a instalação completa? [S/N] "
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
        ADICIONAR_REPOSITORIOS="s"
        ADICIONAR_CHAVES="s"
        PROCESSAR_DEBS="s"
        PROCESSAR_APT="s"
        PROCESSAR_COMPACTADOS="s"
        LIBERAR_PARCEIROS="s"
        USAR_DIST_UPGRADE="n"
        ACEITAR_EULAS="s"
        ATUALIZAR_PACOTES="s"
    else
        printarCabecalho
    
        echo -n "[SCRIPT] Registrar repositórios? [S/N] "
        while true; do
            read -r ADICIONAR_REPOSITORIOS
            if [ "$ADICIONAR_REPOSITORIOS" == "s" ] || [ "$ADICIONAR_REPOSITORIOS" == "n" ] || [ "$ADICIONAR_REPOSITORIOS" == "S" ] || [ "$ADICIONAR_REPOSITORIOS" == "N" ]; then
                break
            fi
        done

        if [ "$ADICIONAR_REPOSITORIOS" == "s" ] || [ "$ADICIONAR_REPOSITORIOS" == "S" ]; then 
            echo -n "[SCRIPT] Registrar chaves dos repositórios? [S/N] "
            while true; do
                read -r ADICIONAR_CHAVES
                if [ "$ADICIONAR_CHAVES" == "s" ] || [ "$ADICIONAR_CHAVES" == "n" ] || [ "$ADICIONAR_CHAVES" == "S" ] || [ "$ADICIONAR_CHAVES" == "N" ]; then
                    break
                fi
            done
        fi

        echo -n "[SCRIPT] Baixar e instalar os arquivos .deb? [S/N] "
        while true; do
            read -r PROCESSAR_DEBS
            if [ "$PROCESSAR_DEBS" == "s" ] || [ "$PROCESSAR_DEBS" == "n" ] || [ "$PROCESSAR_DEBS" == "S" ] || [ "$PROCESSAR_DEBS" == "N" ]; then
                break
            fi
        done

        echo -n "[SCRIPT] Baixar e instalar os programas por apt? [S/N] "
        while true; do
            read -r PROCESSAR_APT
            if [ "$PROCESSAR_APT" == "s" ] || [ "$PROCESSAR_APT" == "n" ] || [ "$PROCESSAR_APT" == "S" ] || [ "$PROCESSAR_APT" == "N" ]; then
                break
            fi
        done

        echo -n "[SCRIPT] Baixar e extrair em pastas os programas compactados? [S/N] "
        while true; do
            read -r PROCESSAR_COMPACTADOS
            if [ "$PROCESSAR_COMPACTADOS" == "s" ] || [ "$PROCESSAR_COMPACTADOS" == "n" ] || [ "$PROCESSAR_COMPACTADOS" == "S" ] || [ "$PROCESSAR_COMPACTADOS" == "N" ]; then
                break
            fi
        done

        echo -n "[SCRIPT] Aceitar EULAS das instalações? [S/N] "
        while true; do
            read -r ACEITAR_EULAS
            if [ "$ACEITAR_EULAS" == "s" ] || [ "$ACEITAR_EULAS" == "n" ] || [ "$ACEITAR_EULAS" == "S" ] || [ "$ACEITAR_EULAS" == "N" ]; then
                break
            fi
        done

        if [ "$(find /etc/apt/ -name *.list | xargs cat | grep  ^[[:space:]]*deb | grep -v deb-src | grep partner)" == "" ]; then
            echo -n "[SCRIPT] Liberar o repositório de parceiros do Ubuntu? [S/N] "
            while true; do
                read -r LIBERAR_PARCEIROS
                if [ "$LIBERAR_PARCEIROS" == "s" ] || [ "$LIBERAR_PARCEIROS" == "n" ] || [ "$LIBERAR_PARCEIROS" == "S" ] || [ "$LIBERAR_PARCEIROS" == "N" ]; then
                    break
                fi
            done
        fi

        echo -n "[SCRIPT] Atualizar a listagem de pacotes com \"apt update\"? [S/N] "
        while true; do
            read -r ATUALIZAR_PACOTES
            if [ "$ATUALIZAR_PACOTES" == "s" ] || [ "$ATUALIZAR_PACOTES" == "n" ] || [ "$ATUALIZAR_PACOTES" == "S" ] || [ "$ATUALIZAR_PACOTES" == "N" ]; then
                break
            fi
        done

        if [ "$ATUALIZAR_PACOTES" == "s" ] || [ "$ATUALIZAR_PACOTES" == "S" ]; then
            echo -n "[SCRIPT] Atualizar pacotes com \"apt dist-upgrade\" ao invés de \"apt upgrade\"? [S/N] "
            while true; do
                read -r USAR_DIST_UPGRADE
                if [ "$USAR_DIST_UPGRADE" == "s" ] || [ "$USAR_DIST_UPGRADE" == "n" ] || [ "$USAR_DIST_UPGRADE" == "S" ] || [ "$USAR_DIST_UPGRADE" == "N" ]; then
                    break
                fi
            done
        fi

        echo -n "[SCRIPT] Criar um prefixo 32 bits para o Wine (caso seja necessário)? [S/N] "
        while true; do
            read -r PREFIXO_WINE32
            if [ "$PREFIXO_WINE32" == "s" ] || [ "$PREFIXO_WINE32" == "n" ] || [ "$PREFIXO_WINE32" == "S" ] || [ "$PREFIXO_WINE32" == "N" ]; then
                break
            fi
        done
    fi
}

function ativarSudo {
    # Ativar o sudo
    sudo clear
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
    # $2 = [1/0] se vai ou não refazer a variável LISTA
    # Retorna: 1 [Achou] / 0 [Não achou]
    checarComando $1
    if [ "$?" -eq "1" ]; then
        return 1
    fi
    if [ "$2" -eq "1" ]; then
        criarListasDePacotes 0
    fi
    checarPacote $1 0 $QUANTPACOTES
    if [ "$?" -eq "1" ]; then
        return 1
    fi
    return 0
}

function criarListasDePacotes() {
    # $1 = [1/0] se vai ou não imprimir a mensagem da função
    if [ "$1" -eq "1" ]; then
        echo "[SCRIPT] Gerando lista de pacotes dinâmica inicial..."
    fi
    # Lista dinâmica onde serão procurados pacotes com exatidão
    LISTA=($(dpkg --get-selections | grep -v deinstall | awk '{print $1}'))
    # Contagem de resultados da lista 1
    while [ ${LISTA[$QUANTPACOTES]} ]; do 
        QUANTPACOTES=$((QUANTPACOTES + 1))
    done
}

function apt-get_update() {
    echo "[SCRIPT] Atualizando banco de dados de pacotes..."
    sudo apt-get update &>$CONSOLE;
}

function apt-get_dist-upgrade() {
    echo "[SCRIPT] Atualizando pacotes (com \"sudo apt dist-upgrade\")..."
    sudo apt-get dist-upgrade -y &>$CONSOLE;
}

function apt-get_upgrade() {
    echo "[SCRIPT] Atualizando pacotes..."
    sudo apt-get upgrade -y &>$CONSOLE;
}

function apt-get_autoremove() {
    echo "[SCRIPT] limpando pacotes inutilizados..."
    sudo apt-get autoremove -y &>$CONSOLE;
}

function gerarTerminalSecundario() {
    # Criar terminal extra
    echo "[SCRIPT] Gerando e linkando um terminal secundário..."
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

function instalarTtyecho() {
    # Compilar e instalar "ttyecho" - programa que executa comandos em outro terminal
    command -v ttyecho >/dev/null 2>&1 || {
        echo -n "[SCRIPT] Compilando e ativando ttyecho"
        checarComando "gcc"
        if [ "$?" -eq "0" ]; then
            echo " (Requisito: gcc)..."
            sudo apt-get install gcc-multilib -y >& $CONSOLE;
        else
            echo "..."
        fi
        cd "../external/"
        gcc ttyecho.c -o ttyecho >& $CONSOLE;
        sudo mv ttyecho "/usr/bin" >& $CONSOLE;
        cd "$DIR_BASE"
    }
}

function adicionarPPA() {
    # $1 = ppa
    # $2 = termo usado para checar se esse ppa já existe
    if ! grep -q "$2" /etc/apt/sources.list /etc/apt/sources.list.d/* >/dev/null 2>&1; then # O Grep olha dentro dos arquivos
        echo "[SCRIPT] Adicionando PPA \"$1\"..." &>$CONSOLE;
        sudo add-apt-repository "$1" -y &>$CONSOLE;
    fi
}

function adicionarPPA2() {
    # $1 = ppa
    # $2 = arquivo onde ficará o ppa
    # $3 = termo para impressão
    if [ ! -f "/etc/apt/sources.list.d/$2" ]; then
        echo "[SCRIPT] Adicionando PPA do $3..." &>$CONSOLE;
        echo "$1" >> "$2"
        sudo mv "$2" "/etc/apt/sources.list.d/"
    fi
}

function adicionarChave() {
    # $1 = servidor da chave
    # $2 = chave
    # $3 = termo para impressão
    if gpg --list-keys "$2" >/dev/null 2>&1; then
        echo "[SCRIPT] Adicionando chave do $3..." &>$CONSOLE;
        sudo apt-key adv --keyserver "$1" --recv-keys "$2" &>$CONSOLE;
    fi
}

function adicionarChave2() {
    # $1 = download da chave
    # $2 = termo para impressão
    echo "[SCRIPT] Adicionando chave do $2..." &>$CONSOLE;
    wget -qO - $1 | sudo apt-key add - &>$CONSOLE;
}

function liberarRepositorioParceirosCanonical() {
    echo "[SCRIPT] Ativando repositório de parceiros da Canonical..."
    sudo sed -i "/^# deb .*partner/ s/^# //" /etc/apt/sources.list &>$CONSOLE;
}

function aceitarEula() {
    # $1 = nome do pacote que requer a automatização
    # $2 = seção de eula que será marcada
    # $3 = item de seção a ser configurado
    # $4 = valor do item de seção
    if [ "$(sudo debconf-show $1 | grep $2)" == "" ]; then
        echo "[SCRIPT] Automatizando instalação de \"$1\"..."
        echo $1 $2 $3 $4 | sudo debconf-set-selections
        LIB=1
    fi
}

function instalarApt() {
    # $1 = pacote a ser instalado via apt-get
    # $2 = algum parâmetro qualquer
    local JUNTAR=$1
    JUNTAR+=" "
    JUNTAR+=$2
    printf "[SCRIPT] %-40s" "$JUNTAR"
    checarExistenciaPacoteOuComando $1 0
    local RES=$?
    if [ "$RES" -eq "1" ]; then
        printf "  [  OK  ]\n"
    else
        echo "[SCRIPT] $1 $2" &>$CONSOLE;
        sudo apt-get install $1 $2 -y &>$CONSOLE;
        dpkg -s "$1" &>$CONSOLE;
        checarExistenciaPacoteOuComando $1 1
        RES=$?
        if [ "$RES" -eq "0" ]; then
            printf "  [ NOPE ]\n"
        else
            printf "⟳ [  OK  ]\n"
        fi
    fi
}

function instalarDeb() {
    # $1 = nome do pacote
    # $2 = link de download
    checarExistenciaPacoteOuComando $1 0
    local RES=$?
    printf "[SCRIPT] %-40s" $1
    if [ "$RES" -eq "1" ]; then
        printf "  [  OK  ]\n"
    else
        local NOME="${1}.deb"
        wget -O $NOME $2 &>$CONSOLE;
        sudo dpkg -i *.deb -f -y &>$CONSOLE;
        sudo apt-get -f install -y &>$CONSOLE;
        checarExistenciaPacoteOuComando $1 1
        if [ "$?" -eq "0" ]; then
            printf "  [ NOPE ]\n"
        else
            printf "⟳ [  OK  ]\n"
        fi
        rm *.deb &>$CONSOLE;
    fi
}

function baixarEExtrair() {
    # $1 = nome da pasta onde iremos extrair o pacote
    # $1 = extensão do pacote (zip, rar ou tar.gz)
    # $2 = link de download
    printf "[SCRIPT] %-40s" "$1"
    check=~/$1
    if test -d "$check"
    then
        printf "  [  OK  ]\n"
    else
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
            printf "  [ NOPE ]\n"
            cd ~/
            rm -r "$1"
            return
        elif [ $quant -eq 1 ]; then
            dir=$(find . -mindepth 1 -maxdepth 1 -type d)
            mv $dir/* ./ &>$CONSOLE;
            rm -r $dir &>$CONSOLE;
        fi
        cd "$DIR_BASE"
        printf "⟳ [  OK  ]\n"
    fi
}

function iniciarTlp() {
    checarExistenciaPacoteOuComando "tlp" 0
    RES=$?
    if [ "$RES" -ne "0" ]; then
        if [[ $(sudo service tlp status) != *"active (exited)"* ]]; then
            echo "[SCRIPT] Iniciando TLP..."
            sudo tlp start &>$CONSOLE;
            sudo service tlp start &>$CONSOLE;
        fi
    fi
}

function criarPrefixoWine32Bits() {
    checarExistenciaPacoteOuComando "wine" 0
    RES=$?
    if [ "$RES" -ne "0" ]; then
        if [ ! -d "$HOME/.wine" ]; then
            echo "[SCRIPT] Criando prefixo padrão de 32bits para o Wine"
            WINEPREFIX=$HOME/.wine WINEARCH='win32' wine 'wineboot' &>$CONSOLE;
            echo
        fi
    fi
}

function removerTerminalSecundario() {
    echo "[SCRIPT] Removendo terminal secundário..."
    if [ -f "../external/console.txt" ]; then
        rm ../external/console.txt
    fi
    sudo ttyecho -n $CONSOLE exit
}

function finalizar() {
    read -p "[SCRIPT] Tudo pronto! Aperte \"Enter\" para finalizar (Isso removerá o terminal secundário)."
    echo
    removerTerminalSecundario
}

