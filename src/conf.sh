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
        conf-set "$file" "$key" "$fallback"
        echo $fallback
    else
        echo $value
    fi
}

jop-set() {
    conf-set $conf_file "$@"
}

jop-get() {
    conf-get $conf_file "$@"
}

jop-get-remote() {
    if $(jop-is-expired remote_conf_update_time +5 minutes); then
        cd $cur_dir
        curl https://gitee.com/7hens/jop/raw/$(git-head-branch)/jop.conf > $remote_conf_file 2>/dev/null
        jop-set remote_conf_update_time "$(date)"
    fi
    conf-get "$remote_conf_file" "$@"
}

jop-expired-time() {
    local key=$1
    local remaining_time=${@:2}
    local record=$(jop-get $key "$(os-x date -d @0)")
    os-x date -d "$record $remaining_time"
}

jop-is-expired() {
    local key=$1
    local remaining_time=${@:2}
    local expired_time=$(jop-expired-time "$key" "$remaining_time")
    test $(date +%s) -ge $(os-x date -d "$expired_time" +%s)
    return $?
}

jop-conf() {
    local file=$conf_file
    if [ "$1" == '-e' ]; then
        vim -n $file
    else
        cat $file
    fi
}

jop-ver() {
    if [ "$1" == "-r" ]; then
        jop-get-remote jop_ver
        return 0
    fi
    conf-get $cur_dir/jop.conf jop_ver
}
