function gitClone() {
    # $1 = Repository
    # $2 = folder
    # Returns: 1 [Success] / 0 [Failed]
    local link=$1
    local dir="$2"
    local name="$(basename $link .git)"
    
    if [ "$dir" = "" ]; then
        dir="$name"
    fi

    run "cd $dir"
    if [ "$?" -eq 1 ]; then
        printfDebug "Already cloned $name"
        return 1
    else
        git clone $link "$dir" &>>"$FILE_LOG";
    fi
    run "cd $dir"
    if [ "$?" -eq 1 ]; then
        printfDebug "Finished cloning $name"
    else
        printfError "Failed to clone $name"
        return 0
    fi

    return 1
}
