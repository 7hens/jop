#!/bin/bash

main() {
    export LANG=en_US.UTF-8
    local cmd=$1
    shift

    if [ "$cmd" = "reinit" ]; then
        jop-reinit "$@"
    else
        if [ "$cmd" = "--" ]; then
            cmd=$1
            shift
        else
            jop-init
            cd $notes_dir

            if $(jop-is-expired last_upgrade_time +2 hours); then
                jop-upgrade
            fi
        fi

        if [ "$(type -t jop-$cmd)" == function ]; then
            jop-$cmd "$@"
        elif $(which $cmd > /dev/null); then
            $cmd "$@"
        elif [ -z $1 ]; then
            jop-get $cmd
        else
            jop-set $cmd "$@"
        fi
    fi
}
