function addStringToFile() {
    # $1 = Target file
    # $2 = Term to be searched
    # $3 = String to be inserted
    local target="$1"
    local search_term="$(echo "$2" | sed -e 's/\//\\\//g')"
    local insert="$3"

    echo "$insert" | sudo tee -a "tempStrAppend.txt" > /dev/null
    sudo sed -E "/$search_term/r tempStrAppend.txt" "$target" | sudo tee -a "tempStrAppend2.txt" > /dev/null
    sudo mv "tempStrAppend2.txt" "$target"
    sudo rm "tempStrAppend.txt"
}

function replaceStringInFile() {
    # $1 = Term to be searched
    # $2 = String to be inserted
    # $3 = Target file
    local target="$1"
    local search_term="$(echo "$2" | sed -e 's/\//\\\//g')"
    local insert="$(echo "$3" | sed -e 's/\//\\\//g')"

    sudo cat "$target" | sudo sed -e "s/$search_term/$insert/" > "tempStrReplace.txt"
    sudo mv "tempStrReplace.txt" "$target"
}

function isStringEmpty() {
    # $1 = String
    # Returns: 1 [Empty] / 0 [Not empty]
    local trimmed=`echo $1`

    if [ -z "$trimmed" ]; then
        return 1
    else
        return 0
    fi
}

function pad() {
    # $1 = String
    # $2 = Padding size
    # $3 = Padding char
    # $4 = Padding type. 0 = Right, 1 = Left, 2 = Both
    # Returns: Padded string
    local string_trimmed=`echo $1`
    local padding_size=$2
    local padding_char=$3
    local padding_type=$4

    local real_padding_size=$(($padding_size - ${#string_trimmed}))

    if [[ $real_padding_size -lt 0 ]]; then
        echo "$string_trimmed"
        return
    fi

    if [ "$padding_type" = "0" ]; then
        for i in $(eval echo "{1..$real_padding_size}"); do
            printf "$padding_char"
        done
        printf "$string_trimmed"
        printf '\n'
    elif [ "$padding_type" = "1" ]; then
        printf "$string_trimmed"
        for i in $(eval echo "{1..$real_padding_size}"); do
            printf "$padding_char"
        done
        printf '\n'
    elif [ "$padding_type" = "2" ]; then
        for i in $(eval echo "{1..$real_padding_size}"); do
            printf "$padding_char"
        done
        printf "$string_trimmed"
        for i in $(eval echo "{1..$real_padding_size}"); do
            printf "$padding_char"
        done
        printf '\n'
    fi
}