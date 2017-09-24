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
VERSAO="v1.5.1 (24/09/17)"
# __________________________________________________________________________


# -------------------------------------------------------------
# Variáveis globais
# -------------------------------------------------------------

# Pasta atual
DIR_BASE="$(cd "${0%/*}" && echo $PWD)"

# Codinome do sistema
CODENOME="$(lsb_release -c | awk '{print $2}')"

# Opções a serem preenchidas pelo usuário
INSTALACAO_PADRAO=""
ADICIONAR_CHAVES=""
ADICIONAR_REPOSITORIOS=""
PROCESSAR_DEBS=""
PROCESSAR_APT=""
PROCESSAR_COMPACTADOS=""
LIBERAR_PARCEIROS=""
ATUALIZAR_PACOTES=""
USAR_DIST_UPGRADE=""
ACEITAR_EULAS=""
PREFIXO_WINE32=""

# Terminal secundário
CONSOLE=""

# Listagem de pacotes instalados
LISTA=""

# Variável para guardar a quantidade de itens em LISTA
QUANTPACOTES=0

# Variável auxiliar para imprimirmos alguns espaços corretamente
LIB=0

# Variável auxiliar para imprimirmos algumas frases corretamente
AUX_PRINT=1

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
echo "❱ Criando e conectando um terminal secundário..."
gerarTerminalSecundario
instalarTtyecho
echo

# -------------------------------------------------------------
# CHAVES E REPOSITÓRIOS
# -------------------------------------------------------------
# A variável LIB é alterado ou não para 1 dentro das funções chamadas nessa seção

if [ "$LIBERAR_PARCEIROS" == "s" ] || [ "$LIBERAR_PARCEIROS" == "S" ]; then 
    liberarRepositorioParceirosCanonical
fi

if [ "$ADICIONAR_CHAVES" == "s" ] || [ "$ADICIONAR_CHAVES" == "S" ]; then
    adicionarChaves
    AUX_PRINT=1
fi

if [ "$ADICIONAR_REPOSITORIOS" == "s" ] || [ "$ADICIONAR_REPOSITORIOS" == "S" ]; then 
    adicionarPPAs
    AUX_PRINT=1
fi

if [ $LIB -eq 1 ]; then
    echo
fi

# -------------------------------------------------------------
# PREPARAÇÕES COM OS PACOTES DO SISTEMA
# -------------------------------------------------------------

if [ "$ATUALIZAR_PACOTES" == "s" ] || [ "$ATUALIZAR_PACOTES" == "S" ]; then
    echo "❱ Atualizando banco de dados de pacotes..."
    apt-get_update
    if [ "$USAR_DIST_UPGRADE" == "s" ] || [ "$USAR_DIST_UPGRADE" == "S" ]; then
        echo "❱ Atualizando pacotes (com \"sudo apt dist-upgrade\")..."
        apt-get_dist-upgrade
    else
        echo "❱ Atualizando pacotes..."
        apt-get_upgrade
    fi
fi

echo

# -------------------------------------------------------------
# ACEITAÇÃO DE EULAS
# -------------------------------------------------------------

LIB=0

if [ "$ACEITAR_EULAS" == "s" ] || [ "$ACEITAR_EULAS" == "S" ]; then 
    aceitarEulas
    # LIB pode ser alterado para 1 dentro de aceitarEulas

    if [ $LIB -eq 1 ]; then
        echo
    fi
fi

# -------------------------------------------------------------
# INSTALAÇÕES VIA APT-GET
# -------------------------------------------------------------

if [ "$PROCESSAR_APT" == "s" ] || [ "$PROCESSAR_APT" == "S" ]; then 
    echo "❱ Instalando programas por apt-get:"
    echo
    instalacoesApt
    echo
fi

# -------------------------------------------------------------
# INSTALAÇÕES VIA DEB
# -------------------------------------------------------------

if [ "$PROCESSAR_DEBS" == "s" ] || [ "$PROCESSAR_DEBS" == "S" ]; then 
    echo "❱ Instalando debs:"
    echo
    cd ~/Downloads
    instalarDebs
    cd "$DIR_BASE"
    echo
fi

# -------------------------------------------------------------
# INSTALAÇÕES DE PROGRAMAS COMPACTADOS
# -------------------------------------------------------------

if [ "$PROCESSAR_COMPACTADOS" == "s" ] || [ "$PROCESSAR_COMPACTADOS" == "S" ]; then 
    echo "❱ Baixando e extraindo programas compactados:"
    echo
    instalarCompactado
    echo
fi

# -------------------------------------------------------------
# AJUSTES FINAIS
# -------------------------------------------------------------

iniciarTlp # Só roda se o TLP estiver instalado
if [ "$PREFIXO_WINE32" == "s" ] || [ "$PREFIXO_WINE32" == "S" ]; then 
    criarPrefixoWine32Bits
fi
echo "❱ Limpando pacotes inutilizados..."
apt-get_autoremove
echo
finalizar
echo

exit
