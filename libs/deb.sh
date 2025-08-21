function upgradeApt() {
    printfInfo "Updating repositories and upgrading packages"
    sudo apt-get update &>>"$FILE_LOG";
    sudo apt-get upgrade -y &>>"$FILE_LOG";
}

function isDebInstalled() {
    # $1 = Package name
    # Returns: 0 [Installed] / 1 [Not installed]
    local status=$(dpkg-query -W -f='${db:Status-Abbrev}' "$1" 2>/dev/null)

    if [[ "$status" == ii* || "$status" == hi* ]]; then
        return 0
    fi

    return 1
}

function isDebFileInstalled() {
    # $1 = Package
    # Returns 0 if the *same* package (name+version+arch) is already installed.
    # Returns 1 if not installed or different version/arch.
    # Returns 2 on error (bad file, unreadable metadata, etc).
    local deb="$1"
    [[ -f "$deb" ]] || { echo "File not found: $deb" >&2; return 2; }

    local pkg ver arch
    pkg=$(dpkg-deb -f "$deb" Package)       || return 2
    ver=$(dpkg-deb -f "$deb" Version)       || return 2
    arch=$(dpkg-deb -f "$deb" Architecture) || return 2

    # Query installed state/version/arch
    local status inst_ver inst_arch
    if ! read -r status inst_ver inst_arch < <(
        dpkg-query -W -f='${db:Status-Abbrev} ${Version} ${Architecture}\n' "$pkg" 2>/dev/null
    ); then
        return 1
    fi

    # Must be installed ('ii'), same version, and same arch (or deb is 'all')
    [[ "${status:0:2}" == "ii" ]] || return 1
    dpkg --compare-versions "$inst_ver" eq "$ver" || return 1
    if [[ "$arch" != "all" && "$inst_arch" != "$arch" ]]; then
        return 1
    fi

    return 0
}

function installApt() {
    # ... = Packages
    for package in "$@"; do
        isDebInstalled $package
        if [ "$?" -eq 0 ]; then
            printfDebug "Skipping APT: \"$package\""
        else
            printfInfo "Installing APT: \"$package\""
            sudo apt-get install $package -y &>>"$FILE_LOG";

            isDebInstalled $package
            if [ "$?" -eq 0 ]; then
                printfDebug "Installed APT: \"$package\""
            else
                printfError "Failed to install APT: \"$package\""
            fi
        fi
    done
}

function installDeb() {
    # $1 = Download URL or path
    # Returns 0 if success
    # Returns 1 failed to download
    # Returns 2 file doesn't exist
    # Returns 3 on installation error
    local deb_src="$1"
    local package="package.deb"
    local deb_tmp_dir="/tmp/easideb"
    local package_name
    local package_path

    if [[ "$deb_src" = http* ]]; then
        package_path="$deb_tmp_dir/$package"
        mkdir -p "$deb_tmp_dir" &>>"$FILE_LOG"
        printfInfo "Downloading deb from \"$deb_src\""
        if ! wget -O "$package_path" "$deb_src" &>>"$FILE_LOG"; then
            printfError "Failed to download deb \"$deb_src\""
            return 1
        fi
        package_name="$(dpkg-deb -f "$package_path" Package)"
    elif [[ ! -f "$deb_src" ]]; then
        printfError "The provided deb path doesn't exist: \"$deb_src\""
        return 2
    else
        package_path="$deb_src"
        package_name="$(dpkg-deb -f "$deb_src" Package)"
    fi

    printfInfo "Installing deb $package_name"

    isDebFileInstalled "$package_path"
    if [ "$?" -eq 0 ]; then
        printfDebug "Already installed deb: \"$package_name\""
        return 0
    else
        printfDebug "Installing deb: \"$package_name\""
        sudo dpkg -i "$package_path" &>>"$FILE_LOG";
        sudo apt -f install -y &>>"$FILE_LOG";
    fi

    isDebFileInstalled "$package_path"
    local result
    if [ "$?" -eq 0 ]; then
        printfDebug "Installed deb: \"$package_name\""
        result=0
    else
        printfError "Failed to install deb: \"$package_name\""
        result=3
    fi

    if [[ "$deb_src" = http* ]]; then
        sudo rm "$package_path" &>>"$FILE_LOG";
    fi

    return $result
}

function addPPALaunchpad() {
    # $1 = Term to verify the instalation
    # $2 = Repository name from Launchpad
    local term="$1"
    local repository=$2

    if ! grep -q "$term" /etc/apt/sources.list /etc/apt/sources.list.d/* >/dev/null 2>&1; then
        printfInfo "Adding PPA: \"$repository\""
        sudo add-apt-repository "$repository" -y &>>"$FILE_LOG";
        if grep -q "$term" /etc/apt/sources.list /etc/apt/sources.list.d/* >/dev/null 2>&1; then
            printfDebug "Added PPA: \"$repository\""
        else
            printfError "Failed to add PPA: \"$repository\""
        fi
    else
        printfDebug "Skipping PPA: \"$term\""
    fi
}

function addPPA() {
    # $1 = Key name
    # $2 = Repository
    local key_name="$1"
    local repository="$2"

    if [ $IS_APT_KEY_DEPRECATED -eq 0 ]; then
        if [ ! -f "/etc/apt/sources.list.d/$key_name.list" ]; then
            printfInfo "Adding PPA: \"$key_name.list\""
            echo "$repository" >> "$key_name.list"
            sudo mv "$key_name.list" "/etc/apt/sources.list.d/"
            printfDebug "Added PPA: \"$key_name.list\""
        else
            printfDebug "Skipping PPA: \"$key_name.list\""
        fi
    else
        local key_path="$(find /usr/share/keyrings -name "$key_name.*" | grep -v '~')"
        if [ "$key_path" = "" ]; then
            key_path="$(find /etc/apt/keyrings -name "$key_name.*" | grep -v '~')"
            if [ "$key_path" = "" ]; then
                printfError "Failed to add PPA: \"$key_name\""
                return
            fi
        fi

        if [ ! -f "/etc/apt/sources.list.d/$key_name.list" ]; then
            local repository_part="$(echo $repository | sed 's/deb //g')"
            printfInfo "Adding PPA: \"$key_name.list\""
            echo "deb [arch=$ARCH signed-by=$key_path] $repository_part" | sudo tee "/etc/apt/sources.list.d/$key_name.list" > /dev/null
            printfDebug "Added PPA: \"$key_name\""
        else
            printfDebug "Skipping PPA: \"$key_name\""
        fi
    fi
}

function addPPAKeyFromKeyServer() {
    # $1 = Key name
    # $2 = Key location
    # $3 = Key server
    # $4 = Key id
    local key_name="$1"
    local key_location="$2"
    local key_server=$3
    local key_id=$4

    if [ ! -d "$key_location" ]; then
        createDirSudo "$key_location"
    fi

    if [ $IS_APT_KEY_DEPRECATED -eq 0 ]; then
        if ! apt-key list | grep -q "$key_name"; then
            printfInfo "Adding PPA key: \"$key_name\""
            sudo apt-key adv --keyserver $key_server --recv-keys $key_id &>>"$FILE_LOG";
            if apt-key list | grep -q "$key_name"; then
                printfDebug "Added PPA key: \"$key_name\""
            else
                printfError "Failed to add PPA key: \"$key_name\""
            fi
        else
            printfDebug "Skipping PPA key: \"$key_name\""
        fi
    else
        local key_path="$key_location/$key_name.gpg"
        if [ ! -f "$key_path" ]; then
            printfInfo "Adding PPA key: \"$key_name\""
            sudo gpg --homedir /tmp --no-default-keyring --keyring "$key_path" --keyserver $key_server --recv-keys $key_id &>>"$FILE_LOG";
            if [ -f "$key_path" ]; then
                printfDebug "Added PPA key: \"$key_name.gpg\""
            else
                printfError "Failed to add PPA key: \"$key_name.gpg\""
            fi
        else
            printfDebug "Skipping PPA key: \"$key_name.gpg\""
        fi
    fi
}

function addPPAKey() {
    # $1 = Key name
    # $2 = Key location
    # $3 = Key URL
    # $4 = (Optional) Custom key extension (in case some source list doesn't search for a .gpg)
    local key_name="$1"
    local key_location="$2"
    local key_url=$3
    local key_extension=$4

    if [ ! -d "$key_location" ]; then
        createDirSudo "$key_location"
    fi

    if [ $IS_APT_KEY_DEPRECATED -eq 0 ]; then
        if apt-key list | grep -q "$key_name"; then
            printfInfo "Adding PPA key: \"$key_name\""
            wget -qO - $key_url | sudo apt-key add &>>"$FILE_LOG";
            printfDebug "Added PPA key: \"$key_name\""
        else
            printfDebug "Skipping PPA key: \"$key_name\""
        fi
    else
        local extension="gpg"
        if [ ! -z "$key_extension" ]; then
            extension="$key_extension"
        fi
        local key_path="$key_location/$key_name.$extension"
        if [ ! -f "$key_path" ]; then
            printfInfo "Adding PPA key: \"$key_name.$extension\""

            local key="$(curl -fsSL $key_url)"

            if echo $key | grep -q " PGP "; then # Convert PGP to GPG
                curl -fsSL $key_url | sudo gpg --dearmor -o "$key_path" &>>"$FILE_LOG";
            else
                sudo wget -nc -O "$key_path" $key_url &>>"$FILE_LOG";
            fi

            printfDebug "Added PPA key: \"$key_name.$extension\""
        else
            printfDebug "Skipping PPA key: \"$key_name.$extension\""
        fi
    fi
}

function acceptDebEULA() {
    # $1 = Package name
    # $2 = EULA section
    # $3 = EULA section key
    # $4 = Value of the EULA section key
    local package_name="$1"
    local eula_section="$2"
    local eula_section_key="$3"
    local eula_section_value="$4"

    if [ "$(sudo debconf-show $package_name | grep $eula_section)" = "" ]; then
        printfInfo "Accepting deb EULA: \"$package_name\" \"$eula_section $eula_section_key\""
        echo $package_name $eula_section $eula_section_key $eula_section_value | sudo debconf-set-selections &>>"$FILE_LOG";
        printfDebug "Accepted deb EULA: \"$package_name\" \"$eula_section $eula_section_key\""
    else
        printfDebug "Skipping deb EULA: \"$package_name\" \"$eula_section $eula_section_key\""
    fi
}
