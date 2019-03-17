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
LINK="https://github.com/Xalalau/Instalator"
POR="Por Xalalau Xubilozo"
VERSAO="v1.7.6 (16/03/19)"
# __________________________________________________________________________

# -------------------------------------------------------------
# Variáveis de ambiente
# -------------------------------------------------------------

# Isso esconde um aviso que começou a aparecer no Ubuntu 18.04+
export APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1

# -------------------------------------------------------------
# Variáveis globais
# -------------------------------------------------------------

# Pastas
DIR_BASE="$(cd "${0%/*}" && echo $PWD)"
DIR_DOWNLOADS="$(xdg-user-dir DOWNLOAD)"
DIR_INCLUDE="$DIR_BASE/include"
DIR_SCRIPTS="$DIR_INCLUDE/scripts"
DIR_EXTERNAL="$DIR_INCLUDE/external"

# Nome e codinome do sistema
DISTRIBUICAO=""
CODENOME=""

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

# Espaço para impressão da coluna de estados
ESPACO_PRINTF="%-73s"

# -------------------------------------------------------------
# DIRETÓRIO BASE
# -------------------------------------------------------------

cd "$DIR_BASE"

# -------------------------------------------------------------
# FUNÇÕES
# -------------------------------------------------------------

# Funções gerais
source "$DIR_INCLUDE/funcoes.sh"

# Função com as entradas
source "$DIR_INCLUDE/entrada.sh"

# -------------------------------------------------------------
# INÍCIO
# -------------------------------------------------------------

clear
pegarInformacoesDoSistema
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
# A variável AUX_LIB é alterado ou não para 1 dentro das funções chamadas nessa seção

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

if [ "$AUX_LIB" == "1" ]; then
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

criarListasDePacotes

echo

# -------------------------------------------------------------
# ACEITAÇÃO DE EULAS
# -------------------------------------------------------------

AUX_LIB=0

if [ "$ACEITAR_EULAS" == "s" ] || [ "$ACEITAR_EULAS" == "S" ]; then 
	aceitarEulas
	# AUX_LIB pode ser alterado para 1 dentro de aceitarEulas

	if [ "$AUX_LIB" == "1" ]; then
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
	cd "$DIR_DOWNLOADS"
	instalarDebs
	cd "$DIR_BASE"
	echo
fi

# -------------------------------------------------------------
# INSTALAÇÕES DE PROGRAMAS COMPACTADOS
# -------------------------------------------------------------

if [ "$PROCESSAR_COMPACTADOS" == "s" ] || [ "$PROCESSAR_COMPACTADOS" == "S" ]; then 
	echo "❱ Baixando e posicionando progamas:"
	echo
	instalarAvulsos
	echo
fi

# -------------------------------------------------------------
# RODAR SCRIPTS
# -------------------------------------------------------------
if [ "$RODAR_SCRIPTS" == "s" ] || [ "$RODAR_SCRIPTS" == "S" ]; then 
	echo "❱ Rodando scripts:"
	echo
	rodarScripts
	echo
fi

# -------------------------------------------------------------
# AJUSTES FINAIS
# -------------------------------------------------------------

echo "❱ Limpando pacotes inutilizados..."
apt-get_autoremove
echo
finalizar
echo

exit
