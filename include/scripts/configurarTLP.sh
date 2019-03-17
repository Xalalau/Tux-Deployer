checarExistenciaPacoteOuComando "tlp"
RES=$?
if [ "$RES" -ne "0" ]; then
	if [[ $(sudo service tlp status) != *"active (exited)"* ]]; then
		echo2 "sudo tlp start && service tlp start"
		sudo tlp start &>$CONSOLE;
		sudo service tlp start &>$CONSOLE;
		printf "$ATUALIZADO"
	else
		printf "$INSTALADO"
	fi
else
	printf "$FALHOU"
fi
	
