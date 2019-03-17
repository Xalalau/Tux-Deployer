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
	echo "- Rodar scripts únicos de configuração e instalação."
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
		RODAR_SCRIPTS="s"
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

		echo -n "❱ Rodar os scripts embutidos em \"./include/scripts\"? [S/N] "
		while true; do
			read -r RODAR_SCRIPTS
			if [ "$RODAR_SCRIPTS" == "s" ] || [ "$RODAR_SCRIPTS" == "n" ] || [ "$RODAR_SCRIPTS" == "S" ] || [ "$RODAR_SCRIPTS" == "N" ]; then
				break
			fi
		done
	fi
}

function ativarSudo() {
	# Ativar o sudo
	sudo clear
}

function pegarInformacoesDoSistema() {
	source /etc/os-release
	CODENOME="$UBUNTU_CODENAME"
	DISTRIBUICAO="$(grep "PRETTY_NAME" /etc/os-release | awk '{ print $2 }')"
	DISTRIBUICAO="${DISTRIBUICAO,,}"
}

function echo2() {
	# Imprimir texto no terminal secundário
	echo "" &>$CONSOLE;
	echo "$1" &>$CONSOLE;
	echo "--------------------------------------------------------------------------------" &>$CONSOLE;
}

function criarListasDePacotes() {
	# Lista contendo o nome de todos os pacotes instalados no sistema
	LISTA=($(dpkg --get-selections | grep -v deinstall | awk '{print $1}'))
	# Contagem de resultados da lista 1
	while [ ${LISTA[$QUANTPACOTES]} ]; do 
		QUANTPACOTES=$((QUANTPACOTES + 1))
	done
}

function checarPacotePorSubstring() {
	# Busca por uma substring em LISTA (nome do pacote em qualquer posição)
	# Nota: usar apenas em casos especiais! Essa função é muito ruim!
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
	echo2 "sudo apt-get update"
	sudo apt-get update &>$CONSOLE;
}

function apt-get_dist-upgrade() {
	echo2 "sudo apt-get dist-upgrade"
	sudo apt-get dist-upgrade -y &>$CONSOLE;
}

function apt-get_upgrade() {
	echo2 "sudo apt-get upgrade"
	sudo apt-get upgrade -y &>$CONSOLE;
}

function apt-get_autoremove() {
	echo2 "sudo apt-get autoremove"
	sudo apt-get autoremove -y &>$CONSOLE;
}

function gerarTerminalSecundario() {
	cd "$DIR_EXTERNAL"
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
	# "ttyecho" permite que um terminal possa executar comandos em outro
	command -v ttyecho >/dev/null 2>&1 || {
		echo -n "❱ Instalando \"ttyecho\"..."
		cd "$DIR_EXTERNAL"
		if ! [[ -f ttyecho ]]; then
			local requisitos=0
			checarComando "gcc"
			if [ "$?" -eq "0" ]; then
				requisitos=1
			else
				criarListasDePacotes
				checarPacotePorSubstring "libc6-dev"
				if [ "$?" -eq "0" ]; then
				   requisitos=1
				fi
			fi
			if [ "$requisitos" -eq "1" ]; then
				echo " Requisitos:"
				requisitosTtyecho
				echo -n "❱ Copiando ttyecho para \"/usr/bin\"..."
			fi
			echo2 "gcc ttyecho.c -o ttyecho"
			gcc ttyecho.c -o ttyecho >& $CONSOLE;
		fi
		echo2 "sudo cp ttyecho \"/usr/bin\""
		sudo cp ttyecho "/usr/bin" >& $CONSOLE;
		echo
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
			AUX_LIB=1
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
			AUX_LIB=1
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
			AUX_LIB=1
		fi
		echo2 "Chave de \"$3\": sudo apt-key adv --keyserver \"$1\" --recv-keys \"$2\""
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
			AUX_LIB=1
		fi
		echo2 "wget -qO - $1 | sudo apt-key add -"
		wget -qO - $1 | sudo apt-key add - &>$CONSOLE;
	fi
}

function liberarRepositorioParceirosCanonical() {
	if [ "$(find /etc/apt/ -name *.list | xargs cat | grep  ^[[:space:]]*deb | grep -v deb-src | grep partner)" == "" ]; then
		local arquivo=$(grep -rwl '/etc/apt' -e 'partner')		
		
		echo "❱ Ativando repositório de parceiros da Canonical..."
		echo2 "sudo sed -i \"/^# deb .*partner/ s/^# //\" \"$arquivo\""		
		sudo sed -i "/^# deb .*partner/ s/^# //" "$arquivo" &>$CONSOLE;
		AUX_LIB=1
	fi
}

function aceitarEula() {
	# $1 = nome do pacote que requer a automatização
	# $2 = seção de eula que será marcada
	# $3 = item de seção a ser configurado
	# $4 = valor do item de seção
	if [ "$(sudo debconf-show $1 | grep $2)" == "" ]; then
		echo "❱ Aceitando termos, \"$2\"..."
		echo2 "echo $1 $2 $3 $4 | sudo debconf-set-selections"
		echo $1 $2 $3 $4 | sudo debconf-set-selections
		AUX_LIB=1
	fi
}

function instalarApt() {
	# $1 = pacote a ser instalado via apt-get
	# $2 = algum parâmetro qualquer ou --SUBSTRING
	# $3 = --SUBSTRING
	# Nota: --SUBSTRING = a busca pelo pacote será feita na função checarPacotePorSubstring()
	local juntar=$1
	juntar+=" "
	if [ "$2" != "--SUBSTRING" ]; then
		juntar+=$2
	fi
	printf "❱ $ESPACO_PRINTF" "$juntar"
	if [ "$3" != "--SUBSTRING" ] && [ "$2" != "--SUBSTRING" ]; then
		checarExistenciaPacoteOuComando $1
	else
		checarPacotePorSubstring $1
	fi
	local res=$?
	if [ "$res" -eq "1" ]; then
		printf "$INSTALADO"
	else
		echo2 "Instalando \"$1\"..."
		sudo apt-get install $juntar -y &>$CONSOLE;
		dpkg -s "$1" &>$CONSOLE;
		if [ "$3" != "--SUBSTRING" ] && [ "$2" != "--SUBSTRING" ]; then
			criarListasDePacotes
			checarExistenciaPacoteOuComando $1
		else
			checarPacotePorSubstring $1
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
	# $3 = --SUBSTRING = a busca pelo pacote será feita na função checarPacotePorSubstring()
	if [ "$3" != "--SUBSTRING" ]; then
		checarExistenciaPacoteOuComando $1
	else
		checarPacotePorSubstring $1
	fi
	local res=$?
	printf "❱ $ESPACO_PRINTF" "$1"
	if [ "$res" -eq "1" ]; then
		printf "$INSTALADO"
	else
		local nome="${1}.deb"
		echo2 "Instalando \"$1\"..."
		wget -O $nome $2 &>$CONSOLE;
		sudo dpkg -i $nome &>$CONSOLE;
		sudo apt-get -f install -y &>$CONSOLE;
		if [ "$3" != "--SUBSTRING" ]; then
			criarListasDePacotes
			checarExistenciaPacoteOuComando $1
		else
			checarPacotePorSubstring $1
		fi
		if [ "$?" -eq "0" ]; then
			printf "$FALHOU"
		else
			printf "$ATUALIZADO"
		fi
		rm $nome &>$CONSOLE;
	fi
}

function baixarEPosicionar() {
	# $1 = nome da pacote que iremos baixar
	# $2 = extensão do pacote (zip, rar, tar.gz...)
	# $3 = nome da pasta aonde iremos extrair o pacote
	# $4 = link de download
	# $5 = --ROOT = vai instalar como root
	pasta=$3
	if [ "${3:0:1}" == "~" ]; then
		cd ~
		pasta=".${3:1}"
	else
		cd "$DIR_DOWNLOADS"
	fi
	printf "❱ $ESPACO_PRINTF" "$1"
	# Checo se já está tudo certo.
	if test -f "$pasta/$1_instalado.txt"; then
		printf "$INSTALADO"
	else
		local Sudo=""		
		local ponto=""

		echo2 "Baixando e posicionando \"$1\"..."
		# Baixando:
		if [ "$5" == "--ROOT" ]; then
			Sudo+="sudo"
		fi
		$Sudo mkdir -p "$pasta/TEMP" &>$CONSOLE;
		cd "$pasta/TEMP" &>$CONSOLE;
		if [ "$2" != "" ]; then
			ponto+="."
		fi
		$Sudo wget $4 -O "$1$ponto$2" &>$CONSOLE;
		if [ "$2" == "zip" ]; then
			$Sudo unzip ./*.zip &>$CONSOLE;
			$Sudo rm ./*.zip &>$CONSOLE;
		elif [ "$2" == "rar" ]; then
			$Sudo unrar ./*.rar &>$CONSOLE;
			$Sudo rm ./*.rar &>$CONSOLE;
		elif [ "$2" == "tar.gz" ]; then
			$Sudo tar -zxvf ./*.tar.gz &>$CONSOLE;
			$Sudo rm ./*.tar.gz &>$CONSOLE;
		fi
		# Verificando a extração (dentro de $pasta/TEMP para que não haja surpresas):
		local quant1=$(find . -mindepth 1 -maxdepth 1 -type d | wc -l) # Pastas
		local quant2=$(find . -mindepth 1 -maxdepth 1 -type f | wc -l) # Arquivos
		local total=$(( quant1 + quant2 )) # Pastas + Arquivos
		if [ $total -eq 0 ]; then # Se eu não tiver nada na pasta o processo falhou.
			printf "$FALHOU"
			cd "$DIR_DOWNLOADS"
			$Sudo rm -r "$pasta" &>$CONSOLE;
			return
		elif [ $quant1 -eq 1 ] && [ $quant2 -eq 0 ]; then # Se tiver apenas uma subpasta, movo o conteúdo para fora dela e é sucesso.
			dir=$(find . -mindepth 1 -maxdepth 1 -type d)
			cd "$dir"
			$Sudo mv * ../ &>$CONSOLE;
			cd ..
			$Sudo rm -r "$dir" &>$CONSOLE;
		fi # Se tiver um ou mais arquivos é sucesso.
		# Mover arquivos de $pasta/TEMP para $pasta:
		cd ../
		$Sudo mv ./TEMP/* ./ &>$CONSOLE;
		$Sudo rm -r ./TEMP &>$CONSOLE;
		if [ "$Sudo" == "sudo" ]; then
			echo "" | sudo tee -a ./$1_instalado.txt &>$CONSOLE;
		else
			echo "" > $1_instalado.txt &>$CONSOLE;	
		fi
		cd "$DIR_BASE"
		printf "$ATUALIZADO"
	fi
}

function rodarScript() {
	# $1 = nome do script a ser iniciado
	
	printf "❱ $ESPACO_PRINTF" "$1.sh"
	source "$DIR_SCRIPTS/$1.sh"
}

function removerTerminalSecundario() {
	cd "$DIR_BASE"
	if [ -f "$DIR_EXTERNAL/console.txt" ]; then
		echo "❱ Removendo terminal secundário..."
		rm "$DIR_EXTERNAL/console.txt"
	fi
	sudo ttyecho -n $CONSOLE exit
}

function finalizar() {
	echo "--------------------------------------------------------------------------------"
	read -p "❱ Tudo pronto! Aperte \"Enter\" para finalizar."
	echo
	removerTerminalSecundario
}
