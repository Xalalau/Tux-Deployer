function isServiceRegistered() {
    # $1 = Service name
    # Returns: 1 [Found] / 0 [Not found]
    local service_exists="$(systemctl list-units --full -all | grep -F "$1.service")"

    if [ "$service_exists" != "" ]; then
        return 1
    else
        return 0
    fi
}

function runService() {
    # $1 = Service name
    # $2 = Service filename
    # $3 = Service content
    # Returns: 1 [Success] / 0 [Failed]
    local service_name=$1
    local service_filename=$2
    local service_content=$3
    local should_run_daemon_reload=0

    if [ ! -z "$service_filename" ] && [ ! -z "$service_content" ]; then
        local service_path="/etc/systemd/system/$service_filename"

        if [ -f "$service_path" ]; then
            sudo rm "$service_path"
            should_run_daemon_reload=1
        fi

        echo "${service_content}" | sudo tee -a "$service_path" &>> /dev/null
    fi

    isServiceRegistered $service_name
    if [ "$?" -eq 1 ]; then
        if [ $should_run_daemon_reload -eq 1 ]; then
            sudo systemctl daemon-reload &>>"$FILE_LOG";
        fi

        run "sudo systemctl restart $service_name" 
        if [ "$?" -eq 1 ]; then
            printfDebug "$service_name restarted"
            return 1
        else
            printfError "Failed to restart $service_name"
            return 0
        fi
    else
        sudo systemctl enable $service_name &>>"$FILE_LOG";

        run "sudo systemctl start $service_name"
        if [ "$?" -eq 1 ]; then
            printfDebug "$service_name started"
            return 1
        else
            printfError "Failed to start $service_name"
            return 0
        fi
    fi
}