{
	isDebInstalled "libreoffice-core"
	if [ "$?" -eq 0 ]; then
		installApt "libreoffice"
	else
		printfDebug "Skipping APT: libreoffice"
	fi
}