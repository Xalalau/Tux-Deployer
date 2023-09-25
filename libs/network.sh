function getActiveNetworkInterface() {
    # Returns: active network interface
    echo "$(ip route | awk '/default/ {print $5; exit}')"
}

function getNetworkRenderer() {
    # Returns: network renderer

    commandExists "nmcli"
    nmcli_exists="$?"
    commandExists "networkctl"
    networkctl_exists="$?"

    if [ "$nmcli_exists" -eq 1 ] && [ "$(nmcli d | grep -E 'unavailable|connected')" ]; then
        echo 'NetworkManager'
    elif [ "$networkctl_exists" -eq 1 ] && [ "$(networkctl -a | grep -E 'routable|degraded|off')" ]; then
        echo 'networkd'
    elif [ "$FILE_NETPLAN" != "" ]; then
        echo "$(cat "$FILE_NETPLAN" | awk '/renderer/ {print $2; exit}')"
    fi
}

function getGateway() {
    # Returns: network gateway
    echo "$(ip route | awk '/default/ {print $3; exit}')"
}

function getInternalIP() {
    # Returns: private IP
    echo "$(hostname -I | cut -d' ' -f1)"
}

function isInternalIPDynamic() {
    # Returns: 1 [dynamic] / 0 [static]
    local internal_ip="$(getInternalIP)"
    local is_dynamic=$(ip route | grep "$internal_ip" | grep dhcp)

    if [ "$is_dynamic" = "" ]; then
        return 0
    else
        return 1
    fi
}

function showPhysicalNetworkInterfaceNames() {
    # Returns: network interface names excluding the virtual ones
    local interfaces="$(find /sys/class/net -mindepth 1 -maxdepth 1 -lname '*virtual*' -prune -o -printf '%f\n')"
    echo "$interfaces"
}

function getNetworkInterfaceMAC() {
    # $1 = Network interface
    # Returns: network MAC
    local network_interface=$1
    local mac
    read mac < /sys/class/net/$network_interface/address &> /dev/null
    echo $mac
}

function getCurrentSubmaskBits() {
    # $1 = Network interface
    # Returns: network submask
    local network_interface=$1
    echo "$(ip -o -f inet addr show | awk '/scope global/ {print $2,$4}' | grep $network_interface  | cut -d '/' -f2)"
}

function getSubmaskBits() {
    # $1 = Network submask IP
    # Returns: submask bits [Success] / -1 [Failed]
    local octets=$1
    local bits=0

    if [ "$octets" = "" ]; then
        return
    fi

    local octets_size="${#octets}"

    if [ $octets_size -le 2 ]; then
        return $octets
    fi

    export IFS="."
    for octet in $octets; do
        if [ $octet = "0" ]; then
            return $bits
        elif [ $octet = "255" ]; then
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

    if [ "$bits" = "" ]; then
        return
    fi

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