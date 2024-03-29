{
	commandExists "wine"
	if [ "$?" -eq 1 ]; then
		if [ ! -d "/home/$USER_CURRENT/.wine/drive_c" ]; then
			printfInfo "Initializing Wine default perfix"
			WINEPREFIX="/home/$USER_CURRENT/.wine" WINEARCH='win32' wine 'wineboot' &>>"$FILE_LOG";
		else
			printfDebug "Wine default prefix already exists"
		fi
	else
		printfWarning "Wine isn't installed"
	fi
}
