function getSubmaskBits() {
    # $1 = Network submask IP
    # Returns: submask bits [Success] / -1 [Failed]
    local octets=$1
    local bits=0

    local octets_size="${#octets}"

    if [ $octets_size -le 2 ]; then
        return $octets
    fi

    export IFS="."
    for octet in $octets; do
        if [ $octet == "0" ]; then
            return $bits
        elif [ $octet == "255" ]; then
            bits=$((bits + 8))
        else
            local test_bits=128

            while [ $test_bits -ge 4 ]; do
                if [ $octet -eq 0 ]; then
                    return $bits
                elif [ $octet -lt $test_bits ]; then
                    return -1
                else
                    bits=$((bits + 1))
                    octet=$((octet - test_bits))
                fi

                test_bits=$((test_bits/2))
            done
        fi
    done
}

function getSubmaskIP() {
    # $1 = Network submask bits
    # Returns: submask IP [Success] / "" [Failed]
    local bits=$1
    local octets=""

    local bits_size="${#bits}"

    if [ $bits_size -gt 2 ]; then
        return $bits
    fi

    while [ $bits -gt 0 ]; do
        bits=$((bits - 8))

        if [ $bits -lt 0 ]; then
            return
        else
            octets="${octets}255."

            if [ $bits -ge 8 ]; then
                continue
            fi

            add_int=128
            last_octet=0

            while [ $bits -gt 0 ]; do
                last_octet=$((last_octet + add_int))
                bits=$((bits - 1))
                add_int=$((add_int/2))

                if [ $add_int -lt 1 ]; then
                    echo ""
                    return
                fi
            done

            octets="$octets$last_octet"
        fi
    done

    echo "$octets"
}