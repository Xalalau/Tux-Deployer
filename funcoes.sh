# !/bin/bash

function ativarSudo {
    # Ativar o sudo
    sudo clear
}

function gerarTerminalSecundario() {
    # Criar terminal extra
    checarComando "gnome-terminal"
    local RES=$?
    if [ "$RES" -eq "0" ]; then
        sudo apt-get install gnome-terminal
    fi
    clear
    echo "[SCRIPT] Gerando e linkando segundo terminal..."
    if ! [ -f console.txt ]; then
        gnome-terminal -x sh -c "clear; tty > console.txt; bash"
        sleep 0.1
        CONSOLE=$(cat console.txt)
    else
        CONSOLE=$(cat console.txt)
        if ! echo >& $CONSOLE; then
            gnome-terminal -x sh -c "clear; tty > console.txt; bash"
            sleep 0.1
            CONSOLE=$(cat console.txt)
        fi
    fi
    echo "" >& $CONSOLE
}

function instalarTtyecho() {
    # Compilar e instalar "ttyecho" - programa que executa comandos em outro terminal
    command -v ttyecho >/dev/null 2>&1 || {
        echo "[SCRIPT] Compilando e ativando ttyecho..."
        make ttyecho >& $CONSOLE;
        cd ~
        sudo mv "$DIR_BASE/ttyecho" "/usr/bin" >& $CONSOLE;
        cd "$DIR_BASE"
    }
}

function definirOpcoes() {
    echo -n "[SCRIPT] Registrar repositórios do script? [S/N] "
    while true; do
        read -r ADICIONAR_REPOSITORIOS
        if [ "$ADICIONAR_REPOSITORIOS" == "s" ] || [ "$ADICIONAR_REPOSITORIOS" == "n" ] || [ "$ADICIONAR_REPOSITORIOS" == "S" ] || [ "$ADICIONAR_REPOSITORIOS" == "N" ]; then
            break
        fi
    done

    if [ "$ADICIONAR_REPOSITORIOS" == "s" ] || [ "$ADICIONAR_REPOSITORIOS" == "S" ]; then 
        echo -n "[SCRIPT] Registrar chaves dos repositórios do script? [S/N] "
        while true; do
            read -r ADICIONAR_CHAVES
            if [ "$ADICIONAR_CHAVES" == "s" ] || [ "$ADICIONAR_CHAVES" == "n" ] || [ "$ADICIONAR_CHAVES" == "S" ] || [ "$ADICIONAR_CHAVES" == "N" ]; then
                break
            fi
        done
    fi

    echo -n "[SCRIPT] Baixar e instalar os debs do script? [S/N] "
    while true; do
        read -r PROCESSAR_DEBS
        if [ "$PROCESSAR_DEBS" == "s" ] || [ "$PROCESSAR_DEBS" == "n" ] || [ "$PROCESSAR_DEBS" == "S" ] || [ "$PROCESSAR_DEBS" == "N" ]; then
            break
        fi
    done

    if [ ! $(find /etc/apt/ -name *.list | xargs cat | grep  ^[[:space:]]*deb | grep -v deb-src | grep partner) ]; then
        echo -n "[SCRIPT] Liberar repositório de parceiros do Ubuntu? [S/N] "
        while true; do
            read -r LIBERAR_PARCEIROS
            if [ "$LIBERAR_PARCEIROS" == "s" ] || [ "$LIBERAR_PARCEIROS" == "n" ] || [ "$LIBERAR_PARCEIROS" == "S" ] || [ "$LIBERAR_PARCEIROS" == "N" ]; then
                break
            fi
        done
    fi
}

function adicionarPPA() {
    # $1 = ppa
    # $2 = termo usado para checar se esse ppa já existe
    if ! grep -q "$2" /etc/apt/sources.list /etc/apt/sources.list.d/* >/dev/null 2>&1; then # O Grep olha dentro dos arquivos
        echo "[SCRIPT] $2" &>$CONSOLE;
        sudo add-apt-repository "$1" -y &>$CONSOLE;
    fi
}

function adicionarPPA2() {
    # $1 = ppa
    # $2 = arquivo onde ficará o ppa
    # $3 = termo para impressão
    if [ ! -f "/etc/apt/sources.list.d/$2" ]; then
        echo "[SCRIPT] Adicionando ppa do $3..." &>$CONSOLE;
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

function liberarRepositorioParceirosUbuntu() {
    if [ "$LIBERAR_PARCEIROS" == "s" ] || [ "$LIBERAR_PARCEIROS" == "S" ]; then 
        echo "[SCRIPT] Ativando repositório de parceiros do Ubuntu..."
        sudo sed -i "/^# deb .*partner/ s/^# //" /etc/apt/sources.list &>$CONSOLE;
        LIB=1
    fi
}

function aceitarEula() {
    # $1 = nome do pacote que será instalado posteriormente
    # $1 = nome do elemento que requer a aceitação
    # $2 = arquivo de eula que será marcado
    # $3 = opção a ser configurada
    # $4 = valor da opção
    if [[ $LISTA2 != *"$1"* ]]; then
        echo "[SCRIPT] Automatizando instalação de $1, item \"$2\"..."
        echo $2 $3 $4 $5 | sudo debconf-set-selections
        LIB=1
    fi
}

function instalarApt() {
    # $1 = pacote a ser instalado via apt-get
    printf "[SCRIPT] %-40s" $1
    checarExistenciaPacoteOuComando $1 0
    local RES=$?
    if [ "$RES" -eq "1" ]; then
        printf "  [  OK  ]\n"
    else
        echo "[SCRIPT] $1" &>$CONSOLE;
        sudo apt-get install $1 -y &>$CONSOLE;
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
        wget $2 &>$CONSOLE;
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

function checarExistenciaPacoteOuComando() {
    # $1 = nome do pacote
    # $2 = [1/0] se vai ou não refazer a variável LISTA
    # Retorna: 1 [Achou] / 0 [Não achou]
    checarComando $1
    if [ "$?" -eq "1" ]; then
        return 1
    fi
    if [ "$2" -eq "1" ]; then
        criarListasDePacotes1 0
    fi
    checarPacote $1 0 $QUANTPACOTES
    if [ "$?" -eq "1" ]; then
        return 1
    fi
    return 0
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

function criarListasDePacotes1() {
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

function criarListasDePacotes2() {
    # Lista estática onde serão buscados termos que comprovem a presença de determinados pacotes no sistema
    LISTA2=$(dpkg --get-selections | grep -v deinstall | awk '{print $1}')
}

function iniciarTlp() {
    echo "[SCRIPT] Iniciando TLP..."
    sudo tlp start &>$CONSOLE;
}

function apt-get_update() {
    echo "[SCRIPT] Atualizando banco de dados de pacotes..."
    sudo apt-get update &>$CONSOLE;
}

function apt-get_upgrade() {
    echo "[SCRIPT] Atualizando pacotes..."
    sudo apt-get upgrade -y &>$CONSOLE;
}

function apt-get_autoremove() {
    echo "[SCRIPT] limpando pacotes inutilizados..."
    sudo apt-get autoremove -y &>$CONSOLE;
}

function finalizar() {
    read -p "[SCRIPT] Tudo pronto! Aperte \"Enter\" para finalizar (Isso removerá o terminal secundário)."
    echo
    removerTerminalSecundario
}

function removerTerminalSecundario() {
    echo "[SCRIPT] Removendo terminal secundário..."
    if [ -f "console.txt" ]; then
        rm console.txt
    fi
    sudo ttyecho -n $CONSOLE exit
}
