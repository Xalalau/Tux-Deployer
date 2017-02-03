#!/bin/bash
#-----------
NOME="INSTALEYTOR"
#------------------------------------------------------------
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
# Um script que serve para instalar a droga toda no Ubuntu (versão deb)!!
# Ele também é capaz de detectar o que já foi feito no sistema e com isso
# evita problemas e perda de tempo.
#
LICENCA="MIT"
LINK="https://github.com/xalalau/Instalator"
POR="Por Xalalau Xubilozo"
VERSAO="v1.3 (03/02/17)"
# __________________________________________________________________________


# -------------------------------------------------------------
# Variáveis globais
# -------------------------------------------------------------

# Pasta atual
DIR_BASE="$(cd "${0%/*}" && echo $PWD)"

# Codinome e versão do sistema
CODENOME="$(lsb_release -c | awk '{print $2}')"

# Opções a serem preenchidas pelo usuário
ADICIONAR_CHAVES=""
ADICIONAR_REPOSITORIOS=""
PROCESSAR_DEBS=""
PROCESSAR_APT=""
PROCESSAR_COMPACTADOS=""
LIBERAR_PARCEIROS=""
USAR_DIST_UPGRADE=""

# Terminal secundário
CONSOLE=""

# Listagem de pacotes instalados
LISTA=""

# Variável para guardar a quantidade de itens em LISTA
QUANTPACOTES=0

# Variável auxiliar para imprimirmos alguns espaços corretamente
LIB=0


# -------------------------------------------------------------
# DIRETÓRIO BASE
# -------------------------------------------------------------

cd "$DIR_BASE"

# -------------------------------------------------------------
# FUNÇÕES
# -------------------------------------------------------------

# Funções gerais
source "funcoes.sh"

# Função com os entradas
source "entrada.sh"

# -------------------------------------------------------------
# INÍCIO
# -------------------------------------------------------------

clear
definirOpcoes
echo
ativarSudo
gerarTerminalSecundario
instalarTtyecho
echo

# -------------------------------------------------------------
# CHAVES E REPOSITÓRIOS
# -------------------------------------------------------------

liberarRepositorioParceirosUbuntu

if [ "$ADICIONAR_CHAVES" == "s" ] || [ "$ADICIONAR_CHAVES" == "S" ]; then
    echo "[SCRIPT] Adicionando chaves..."
    adicionarChaves
    LIB=1
fi

if [ "$ADICIONAR_REPOSITORIOS" == "s" ] || [ "$ADICIONAR_REPOSITORIOS" == "S" ]; then 
    echo "[SCRIPT] Adicionando repositórios..."
    adicionarPPAs
    LIB=1
fi

if [ $LIB -eq 1 ]; then
    echo
fi

# -------------------------------------------------------------
# PREPARAÇÕES COM OS PACOTES DO SISTEMA
# -------------------------------------------------------------

apt-get_update
if [ "$USAR_DIST_UPGRADE" == "s" ] || [ "$USAR_DIST_UPGRADE" == "S" ]; then
    apt-get_dist-upgrade
else
    apt-get_upgrade
fi
criarListasDePacotes 1
echo

# -------------------------------------------------------------
# ACEITAÇÃO DE EULAS
# -------------------------------------------------------------

LIB=0

aceitarEulas

if [ $LIB -eq 1 ]; then
    echo
fi

# -------------------------------------------------------------
# INSTALAÇÕES VIA DEB
# -------------------------------------------------------------

if [ "$PROCESSAR_DEBS" == "s" ] || [ "$PROCESSAR_DEBS" == "S" ]; then 
    echo "[SCRIPT] Instalando debs:"
    echo
    cd ~/Downloads
    instalarDebs
    cd "$DIR_BASE"
    echo
fi

# -------------------------------------------------------------
# INSTALAÇÕES VIA APT-GET
# -------------------------------------------------------------

if [ "$PROCESSAR_APT" == "s" ] || [ "$PROCESSAR_APT" == "S" ]; then 
    echo "[SCRIPT] Instalando programas por apt-get:"
    echo
    instalacoesApt
    echo
fi

# -------------------------------------------------------------
# INSTALAÇÕES DE PROGRAMAS COMPACTADOS
# -------------------------------------------------------------

if [ "$PROCESSAR_COMPACTADOS" == "s" ] || [ "$PROCESSAR_COMPACTADOS" == "S" ]; then 
    echo "[SCRIPT] Baixando e extraindo programas compactados:"
    echo
    instalarCompactado
    echo
fi

# -------------------------------------------------------------
# AJUSTES FINAIS
# -------------------------------------------------------------

iniciarTlp
criarPrefixoWine32Bits
apt-get_autoremove
echo
finalizar
echo

exit
