function createDir() {
    # $1 = Full path
    if [ ! -d "$1" ]; then
        sudo mkdir -p "$1"
        return 1
    fi

    return 0
}

function commandExists() {
    # $1 = Command
    # Returns: 1 [Found] / 0 [Not found]
    type $1 >/dev/null 2>&1 && { 
        return 1
    } || {
        return 0
    }
}

function appendTextAfterMatch() {
    # $1 = Term to be search
    # $2 = String to be inserted
    # $3 = Target file
	local search_term=$1
	local insert=$2
	local target=$3

    echo "$insert" | sudo tee -a "tempStrAppend.txt" > /dev/null
    sudo sed -E "/$search_term/r tempStrAppend.txt" "$target" | sudo tee -a "tempStrAppend2.txt" > /dev/null
    sudo mv "tempStrAppend2.txt" "$target"
    sudo rm "tempStrAppend.txt"
}

function download() {
	# $1 = File
	# $2 = Destiny folder (path)
	# $3 = Download URL
	# $4 and $5 = Options: --ROOT to install as root and --EXTRACT to uncompress files
	local fullfile=$1
	local filename=$(basename -- "$fullfile")
	local extension="${filename##*.}"
	filename="${filename%.*}"
	local path="$2"
	local url=$3
	local options=$4

	if [ "${3:0:1}" == "~" ]; then
		cd ~
		path=".${3:1}"
	else
		cd "$DIR_DOWNLOADS"
	fi

	if [ -f "$path/."$filename"_instalado.txt" ]; then
        printfDebug "Skipping download: \"$fullfile\""
		printf "$INSTALADO"
	else
		local sudo=""		
		local dot=""

		if [ "$4" == "--ROOT" ] || [ "$5" == "--ROOT" ]; then
			sudo+="sudo"
		fi

        # Download and uncompress inside a temporary path
		$sudo mkdir -p "$path/TEMP" &>>"$FILE_LOG";

		cd "$path/TEMP" &>>"$FILE_LOG";

		if [ "$extension" != "" ]; then
			dot+="."
		fi

		printfInfo "Downloading: \"$fullfile\""

		$sudo wget $url -O "$filename$dot$extension" &>>"$FILE_LOG";

		local extracted=0
		if [ "$4" == "--EXTRACT" ] || [ "$5" == "--EXTRACT" ]; then
			printfInfo "Extracting: \"$fullfile\""

			if [ "$extension" == "zip" ]; then
				$sudo unzip "$path/$fullfile" &>>"$FILE_LOG";
			elif [ "$extension" == "rar" ]; then
				$sudo unrar "$path/$fullfile" &>>"$FILE_LOG";
			elif [ "$extension" == "tar.gz" ]; then
				$sudo tar -zxvf "$path/$fullfile" &>>"$FILE_LOG";
			else
				$sudo rm "$path/$fullfile" &>>"$FILE_LOG";
				printfError "Failed to extract: \"$fullfile\""
				return
			fi
			extracted=1
			$sudo rm "$path/$fullfile" &>>"$FILE_LOG";
		fi

		# Check the instalation
        # At least 1 item = success
		local quant1=$(find . -mindepth 1 -maxdepth 1 -type d | wc -l) # folders
		local quant2=$(find . -mindepth 1 -maxdepth 1 -type f | wc -l) # files
		local total=$(( $quant1 + $quant2 ))
		if [ $total -eq 0 ]; then
            # Empty = failed
			printfError "Failed to donwload: \"$fullfile\""
			cd "$DIR_DOWNLOADS"
			$sudo rm -r "$path" &>>"$FILE_LOG";
			return
		elif [ $quant1 -eq 1 ] && [ $quant2 -eq 0 ]; then
            # 1 subfolder = Move its content 1 level up
			local dir=$(find . -mindepth 1 -maxdepth 1 -type d)
			cd "$dir"
			$sudo mv * ../ &>>"$FILE_LOG";
			cd ../../
			$sudo rm -r "$dir" &>>"$FILE_LOG";
        else
            # At least 1 file = Success
            cd ..
		fi
		
        # Move the files to the correct location
		$sudo mv ./TEMP/* ./ &>>"$FILE_LOG";
		$sudo rm -r ./TEMP &>>"$FILE_LOG";
		if [ "$sudo" == "sudo" ]; then
			echo "" | sudo tee -a "$path/."$filename"_instalado.txt" > /dev/null
		else
			echo "" > "$path/."$filename"_instalado.txt" &>>"$FILE_LOG";	
		fi

		cd "$DIR_BASE"

		if [ $extracted -eq 1 ]; then
			printfInfo "Downloaded and extracted: \"$fullfile\""
		else
			printfInfo "Downloaded: \"$fullfile\""
		fi
	fi
}
