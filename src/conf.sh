#!/bin/bash

conf() {
    if [ "$1" == '-e' ]; then
        vim -n $conf_file
    else
        cat $conf_file
    fi
}

conf-set() {
    local file=$conf_file
    local key=$1
    local value=$2
    if [ -z $key ]; then
        err conf-set $file: empty key
        return 1
    fi
    local match=$(sed -n "s#^$key=.*\$#\0#p" $file)
    if [ "$match" == "" ]; then
        echo $key=$value>>$file
    else
        file-replace $file $key $value
    fi
    # file-w2u $file
    # echo $value
}

conf-get() {
    local file=$conf_file
    local key=$1
    local fallback=$2
    if [ -z $key ]; then
        err ERROR: conf-get $file: empty key
        return 1
    fi
    local value=$(sed -n "s#^$key=\(.*\)\$#\1#p" $file)
    if [[ -z $value && -n $fallback ]]; then
        conf-set $file $key $fallback
        echo $fallback
    else
        echo $value
    fi
}
