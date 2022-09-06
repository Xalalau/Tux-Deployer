{
	isDebInstalled "libreoffice-core"
	if [ "$?" -eq 0 ]; then
		installApt "audacity"
	else
		printfDebug "Skipping APT: libreoffice"
	fi
}