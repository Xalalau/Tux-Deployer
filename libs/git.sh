function gitClone() {
    # $1 = Repository
    # Returns: 1 [Success] / 0 [Failed]
    local link=$1
    local dir=$(basename $link .git)

    run "cd $dir"
    if [ "$?" -eq 1 ]; then
        printfDebug "Already cloned $dir"
        return 1
    else
        git clone $link &>>"$FILE_LOG";
    fi
    run "cd $dir"
    if [ "$?" -eq 1 ]; then
        printfDebug "Finished cloning $dir"
    else
        printfError "Failed to clone $dir"
        return 0
    fi

    return 1
}
