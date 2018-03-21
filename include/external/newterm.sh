#!/bin/sh
# Usage: name-of-this-file program arg1 arg2 argN
# http://askubuntu.com/posts/46640/revisions
if [ -n "$1" ]; then
    # if there are arguments, put the contents in a file since arguments with spaces could be messed up
    export IAMTEMPFILE=1
    export EXECUTEMEPLOX=$(mktemp)
    echo "$@" > "$EXECUTEMEPLOX"
    nohup x-terminal-emulator -e "$0" >/dev/null 2>&1 &
else
    unset IAMTEMPFILE
    # note: make sure the executed program does not change $EXECUTEMEPLOX
    . "$EXECUTEMEPLOX"
    # and remove the file with the command
    rm -f "$EXECUTEMEPLOX"
    # and replace the current shell with bash
    exec bash
fi
