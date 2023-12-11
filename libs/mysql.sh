function setkeyValue() {
    # $1 = Database name
    # $2 = Table name
    # $3 = Key
    # $4 = Value
    local db=$1
    local tbl=$2
    local key=$3
    local value=$4
    
    local key_exists=$(sudo mysql $db -se "SELECT idx FROM $tbl WHERE \`key\` = '$key'")

    if [ "$key_exists" != "" ]; then
        echo "
            USE $db;
            UPDATE $tbl SET \`value\`='$value' WHERE \`key\`='$key';
        " > /tmp/easitemp.sql
    else
        echo "
            USE $db;
            INSERT INTO $tbl
                (\`key\`, \`value\`)
            VALUES
                ('$key', $value);
        " > /tmp/easitemp.sql
    fi

    local res=$(sudo mysql < /tmp/easitemp.sql 2>&1 >/dev/null)
    if echo $res | grep -q "ERROR"; then
        printfError "Failed to set $key"
        echo $res &>>"$FILE_LOG";
    else
        printfDebug "$key = $value"
    fi
    rm /tmp/easitemp.sql 
}

function truncateTable() {
    # $1 = Database name
    # $2 = Table name
    local db=$1
    local tbl=$2

    local truncate=$(sudo mysql $db -se "TRUNCATE $tbl")

    if echo $truncate | grep -q "ERROR"; then
        printfError "Failed to truncate table $tbl"
        echo $res &>>"$FILE_LOG";
    else
        printfDebug "Table $tbl truncated"
    fi
}

function removekey() {
    # $1 = Database name
    # $2 = Table name
    # $3 = Key
    local db=$1
    local tbl=$2
    local key=$3
    
    local key_exists=$(sudo mysql $db -se "SELECT idx FROM $tbl WHERE \`key\` = '$key'")

    if [ "$key_exists" != "" ]; then
        echo "
            USE $db;
            DELETE FROM $tbl WHERE \`key\`='$key';
        " > /tmp/easitemp.sql

        local res=$(sudo mysql < /tmp/easitemp.sql 2>&1 >/dev/null)
        if echo $res | grep -q "ERROR"; then
            printfError "Failed to remove $key"
            echo $res &>>"$FILE_LOG";
        else
            printfDebug "Key '$key' removed from $tbl"
        fi
        rm /tmp/easitemp.sql 
    else
        printfDebug "$tbl doesn't have a key $key to be removed"
    fi
}