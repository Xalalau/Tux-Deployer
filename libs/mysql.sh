function hasSQLIdx() {
    # $1 = Database name
    # $2 = Table name
    # $3 = Idx
    # Returns: 1 [Exists] / 0 [Doesn't exist]
    local db=$1
    local tbl=$2
    local idx=$3

    local idx_exists=$(sudo mysql $db -se "SELECT idx FROM $tbl WHERE \`idx\` = '$idx'")

    if [ "$idx_exists" != "" ]; then
        return 1
    else
        return 0
    fi
}

function hasSQLKey() {
    # $1 = Database name
    # $2 = Table name
    # $3 = Key
    # Returns: 1 [Exists] / 0 [Doesn't exist]
    local db=$1
    local tbl=$2
    local key=$3

    local key_exists=$(sudo mysql $db -se "SELECT idx FROM $tbl WHERE \`key\` = '$key'")

    if [ "$key_exists" != "" ]; then
        return 1
    else
        return 0
    fi
}

function setSQLValue() {
    # $1 = Database name
    # $2 = Table name
    # $3 = Key
    # $4 = Value
    local db=$1
    local tbl=$2
    local key=$3
    local value=$4

    hasSQLKey "$db" "$tbl" "$key"
    if [ "$?" -eq 1 ]; then
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

function setSQLValueByIdx() {
    # $1 = Database name
    # $2 = Table name
    # $3 = idx
    # $4 = field
    # $5 = Value (String)
    local db=$1
    local tbl=$2
    local idx=$3
    local field=$4
    local value=$5

    hasSQLIdx "$db" "$tbl" "$idx"
    if [ "$?" -eq 1 ]; then
        echo "
            USE $db;
            UPDATE $tbl SET \`$field\`='$value' WHERE \`idx\`=$idx;
        " > /tmp/easitemp.sql
    else
        echo "
            USE $db;
            INSERT INTO $tbl
                (\`idx\`, \`$field\`)
            VALUES
                ($idx, '$value');
        " > /tmp/easitemp.sql
    fi

    local res=$(sudo mysql < /tmp/easitemp.sql 2>&1 >/dev/null)
    if echo $res | grep -q "ERROR"; then
        printfError "Failed to set idx $idx on field $field with value $value in table $tbl"
        echo $res &>>"$FILE_LOG";
    else
        printfDebug "$tbl idx $idx = $value"
    fi
    rm /tmp/easitemp.sql 
}

function getSQLValue() {
    # $1 = Database name
    # $2 = Table name
    # $3 = Key
    # Returns: value
    local db=$1
    local tbl=$2
    local key=$3

    hasSQLKey "$db" "$tbl" "$key"
    if [ "$?" -eq 1 ]; then
        echo "$(sudo mysql $db -se "SELECT \`value\` FROM $tbl WHERE \`key\` = '$key'")"
    else
        printfError "Key '$key' not found in $tbl"
    fi
}

function truncateSQLTable() {
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

function removeSQLkey() {
    # $1 = Database name
    # $2 = Table name
    # $3 = Key
    local db=$1
    local tbl=$2
    local key=$3
    
    hasSQLKey "$db" "$tbl" "$key"
    if [ "$?" -eq 1 ]; then
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
