#!/bin/bash

conf-set() {
    local file=$1
    local key=$2
    local value=$3
    if [ -z $key ]; then
        err conf-set $file: empty key
        return 1
    fi
    local match=$(sed -n "s#^$key=.*\$#\0#p" $file)
    if [ "$match" == "" ]; then
        echo $key=$value>>$file
    else
        sed -i'' -e "s#^$key=.*\$#$key=$value#g" $file
    fi
}

conf-get() {
    local file=$1
    local key=$2
    local fallback=$3
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
