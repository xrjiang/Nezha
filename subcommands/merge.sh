#!/bin/bash
# Author: xingruijiang

usage(){
    echo "Usage: nezha merge { show | never | interval | help }"
    echo ""
    echo "    show: show current merge_window"
    echo "    never: set merge_window to never"
    echo "    always: set merge_window to always"
    echo "    interval: set merge_window base on hostname"
    echo "    help: help message"
    echo ""
    exit 1
}

[ $# = 0 ] && usage

get_exec(){
    if [[ -d "/usr/local/riak1" ]]; then
        EXEC="/usr/local/riak1/bin/riak-md"
    elif [[ -d "/usr/local/riak2" ]]; then
        EXEC="/usr/local/riak2/bin/riak-outil"
    else
        echo "There is neither riak1 nor riak2"
        exit 1
    fi
}

set_interval() {
    local num=$(hostname | awk -F '-' '{print $3}')
    ((num=10#${num}))
    let first=num%6
    let end=first+3

    ${EXEC} setenv bitcask merge_window ${first} ${end}
}

case $1 in
    show)
        get_exec
        ${EXEC} getenv bitcask merge_window
        ;;
    never)
        get_exec
        ${EXEC} setenv bitcask merge_window never
        ;;
    always)
        get_exec
        ${EXEC} setenv bitcask merge_window always
        ;;
    interval)
        get_exec
        set_interval
        ;;
    *)
        usage
        ;;
esac
