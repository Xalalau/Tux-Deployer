function upgradeApt() {
    printfInfo "Updating repositories and upgrading packages"
    sudo apt-get update &>>"$FILE_LOG";
    sudo apt-get upgrade -y &>>"$FILE_LOG";
}

function isDebInstalled() {
    # $1 = Package
    # Returns: 1 [Found] / 0 [Not found]
    local is_installed_check1=$(dpkg -l "$1" 2>/dev/null | grep 'ii  ')
    local is_installed_check2=$(dpkg -l "$1" 2>/dev/null | grep 'hi  ')

    if [ ! -z "$is_installed_check1" ] || [ ! -z "$is_installed_check2" ]; then
        return 1
    fi

    return 0
}

function installApt() {
    # ... = Packages
    for package in "$@"; do
        isDebInstalled $package
        if [ "$?" -eq 1 ]; then
            printfDebug "Skipping APT: \"$package\""
        else
            printfInfo "Installing APT: \"$package\""
            sudo apt-get install $package -y &>>"$FILE_LOG";

            isDebInstalled $package
            if [ "$?" -eq 1 ]; then
                printfDebug "Installed APT: \"$package\""
            else
                printfError "Failed to install APT: \"$package\""
            fi
        fi
    done
}

function installDeb() {
    # $1 = Package name or package command
    # $2 = Download URL
    local package="$1"
    local url=$2

    isDebInstalled $package
    if [ "$?" -eq 1 ]; then
        printfDebug "Skipping deb: \"$package\""
    else
        commandExists $package
        if [ "$?" -eq 1 ]; then
            printfDebug "Skipping deb: \"$package\""
            return
        fi

        local deb_name="${package}.deb"

        printfInfo "Installing deb: \"$deb_name\""

        wget -O $deb_name $url &>>"$FILE_LOG";
        sudo dpkg -i $deb_name &>>"$FILE_LOG";
        sudo apt-get -f install -y &>>"$FILE_LOG";

        isDebInstalled $package
        if [ "$?" -eq 1 ]; then
            printfDebug "Installed deb: \"$package\""
        else
            commandExists $package
            if [ "$?" -eq 1 ]; then
                printfDebug "Installed deb: \"$package\""
            else
                printfError "Failed to install deb: \"$package\""
            fi
        fi

        rm $deb_name;
    fi
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

    if [ "$(sudo debconf-show $package_name | grep $eula_section)" == "" ]; then
        printfInfo "Accepting deb EULA: \"$package_name\" \"$eula_section $eula_section_key\""
        echo $package_name $eula_section $eula_section_key $eula_section_value | sudo debconf-set-selections &>>"$FILE_LOG";
        printfDebug "Accepted deb EULA: \"$package_name\" \"$eula_section $eula_section_key\""
    else
        printfDebug "Skipping deb EULA: \"$package_name\" \"$eula_section $eula_section_key\""
    fi
}