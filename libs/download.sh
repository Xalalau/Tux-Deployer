function download() {
    # $1 = File
    # $2 = Destiny folder (path)
    # $3 = Download URL
    # ... = Options:
    #           --ROOT to install as root
    #           --EXTRACT to uncompress files
    #           --EXTRACT-OVERRIDE to uncompress files over existing ones
    #           --EXTRACT-CLEAR to clear the target dir before uncompressing files
    # Returns: 1 [Success] / 0 [Error]
    local fullfile=$1
    local basename=$(basename -- "$fullfile")
    local extension="${basename##*.}"
    local filename="${basename%.*}"
    local path="$2"
    local url=$3
    local options=$4

    local override=0
    local extract=0
    local clear=0
    local sudo=""

    for arg in "$@"
    do
        if [ "$arg" == "--EXTRACT" ]; then
            extract=1
        elif [ "$arg" == "--ROOT" ]; then
            sudo+="sudo"
        elif [ "$arg" == "--EXTRACT-OVERRIDE" ]; then
            override=1
            extract=1
        elif [ "$arg" == "--EXTRACT-CLEAR" ]; then
            clear=1
            extract=1
        fi
    done

    if [ "${3:0:1}" == "~" ]; then
        cd ~
        path=".${3:1}"
    fi

    if [ -f "$path/."$filename"_installed.txt" ]; then
        if [ $override -eq 1 ]; then
            printfWarning "An older extraction will be overwritten"
        elif [ $clear -eq 1 ]; then
            printfWarning "An older extraction will be removed"
            sudo rm -r "$path"
        else
            if [ $extract -eq 1 ]; then
                printfDebug "Skipping download and extraction: \"$fullfile\""
            else
                printfDebug "Skipping download: \"$fullfile\""
            fi

            return 1
        fi
    fi

    local dot=""

    if [ "$extension" != "" ]; then
        dot+="."
    fi

    # Download and uncompress inside a temporary path
    $sudo mkdir -p "$path/TEMP" &>>"$FILE_LOG";

    cd "$path/TEMP" &>>"$FILE_LOG";

    printfInfo "Downloading: \"$fullfile\""

    # Google drive urls
    local result
    if echo $url | grep -q 'drive.google.com'; then
        if [ $ENABLE_GDRIVE_DOWNLOAD_URLS -eq 0 ]; then
            printfError "Failed to download: \"$fullfile\". Google Drive support is disabled"
            return 0
        else
            parts=($(echo $url | tr "/" "\n"))
            result=$($sudo gdown ${parts[4]} -O "$path/TEMP/$filename$dot$extension" &>>"$FILE_LOG";)
        fi
    else
        result=$($sudo wget $url -O "$path/TEMP/$filename$dot$extension" &>>"$FILE_LOG";)
    fi

    if echo $result | grep -q " ERROR "; then
        sudo rm "$filename$dot$extension"
        printfError "Failed to download: \"$fullfile\""
        return 0
    fi

    local extracted=0
    if [ $extract -eq 1 ]; then
        printfInfo "Extracting: \"$fullfile\""

        if [ "$extension" == "zip" ]; then
            $sudo unzip "$path/TEMP/$fullfile" &>>"$FILE_LOG";
        elif [ "$extension" == "rar" ]; then
            $sudo unrar "$path/TEMP/$fullfile" &>>"$FILE_LOG";
        elif [ "$extension" == "gz" ]; then
            $sudo tar -zxvf "$path/TEMP/$fullfile" &>>"$FILE_LOG";
        else
            $sudo rm "$path/TEMP/$fullfile" &>>"$FILE_LOG";
            printfError "Failed to extract: \"$fullfile\""
            return
        fi
        extracted=1
        $sudo rm "$path/TEMP/$fullfile" &>>"$FILE_LOG";
    fi

    # Check the instalation
    # At least 1 item = success
    local quant1=$(find . -mindepth 1 -maxdepth 1 -type d | wc -l) # folders
    local quant2=$(find . -mindepth 1 -maxdepth 1 -type f | wc -l) # files
    local total=$(( $quant1 + $quant2 ))
    if [ $total -eq 0 ]; then
        # Empty = failed
        printfError "Failed to extract: \"$fullfile\""
        cd "$DIR_BASE"
        $sudo rm -r "$path" &>>"$FILE_LOG";
        return 0
    elif [ $quant1 -eq 1 ] && [ $quant2 -eq 0 ]; then
        # 1 subfolder = Move its content 1 level up
        local dir=$(find . -mindepth 1 -maxdepth 1 -type d)
        cd "$dir"
        $sudo mv * ../ &>>"$FILE_LOG";
        cd ..
        $sudo rm -r "$dir" &>>"$FILE_LOG";
        cd ..
    else
        # At least 1 file = Success
        cd ..
    fi

    # Move the files to the correct location
    $sudo mv ./TEMP/* ./ &>>"$FILE_LOG";
    $sudo rm -r ./TEMP &>>"$FILE_LOG";
    if [ "$sudo" == "sudo" ]; then
        echo "" | sudo tee -a "$path/."$filename"_installed.txt" > /dev/null
    else
        echo "" > "$path/."$filename"_installed.txt" &>>"$FILE_LOG";    
    fi

    cd "$DIR_BASE"

    if [ $extracted -eq 1 ]; then
        printfDebug "Downloaded and extracted: \"$fullfile\""
    else
        printfDebug "Downloaded: \"$fullfile\""
    fi

    return 1
}
