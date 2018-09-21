if [ "$PREFIXO_WINE32" == "s" ] || [ "$PREFIXO_WINE32" == "S" ]; then 
	checarExistenciaPacoteOuComando "wine"
	RES=$?
	if [ "$RES" -ne "0" ]; then
		if [ ! -d "$HOME/.wine/drive_c" ]; then
			echo2 "WINEPREFIX=$HOME/.wine WINEARCH='win32' wine 'wineboot'"
			WINEPREFIX=$HOME/.wine WINEARCH='win32' wine 'wineboot' &>$CONSOLE;
			printf "$ATUALIZADO"
		else
			printf "$INSTALADO"
		fi
	else
		printf "$FALHOU"
	fi
fi
