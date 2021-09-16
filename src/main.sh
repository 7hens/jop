#!/bin/bash

main() {
    local cmd=$1
    shift

    if [ "$cmd" = "reinit" ]; then
        jop-reinit "$@"
    elif [ "$cmd" = "test" ]; then
        jop-test "$@"
    else
        if [ $cmd = "--" ]; then
            cmd=$1
            shift
        else
            jop-init
            cd $notes_dir

            if $(jop-is-expired last_upgrade_time +2 hours); then
                upgrade
            fi
        fi

        if [[ -z "$cmd" || "$cmd" == "main" ]]; then
            jop-sync
        elif [ "$(type -t jop-$cmd)" == function ]; then
            jop-$cmd "$@"
        elif [[ "$(type -t $cmd)" == function || $(which $cmd) != "" ]]; then
            $cmd "$@"
        elif [ -z $1 ]; then
            jop-get $cmd
        else
            jop-set $cmd "$@"
        fi
    fi
}

upgrade() {
    if [ $(jop-ver -r) -lt $(jop-ver) ]; then
        return
    fi
    echo upgrading jop...
    echo " "
    cd $cur_dir
    git-sync
    jop-set last_upgrade_time "$(date)"
}

jop-test() {
    echo '-----------------------------------'
    echo hello, jop v$(jop-ver)
    echo '-----------------------------------'
    echo cur_dir: $cur_dir
    echo cur_fie: $cur_file
    echo conf_file: $conf_file
}
