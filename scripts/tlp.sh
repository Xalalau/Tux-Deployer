{
	commandExists "tlp"
	if [ "$?" -eq 1 ]; then
		if [[ $(sudo service tlp status) != *"active (exited)"* ]]; then
			printfInfo "Starting tlp"
			sudo tlp start &>>"$FILE_LOG";
			sudo service tlp start &>>"$FILE_LOG";
		else
			printfInfo "tlp is already running"
		fi
	else
		printfWarning "tlp isn't installed"
	fi
}