#!/bin/bash

main() {
    cmd=$1
    shift

    if [ "$cmd" == "reinit" ]; then
        jop-reinit "$@"
    elif [ "$cmd" == "test" ]; then
        test "$@"
    else
        jop-init
        cd $notes_dir
        
        if [ $(jop-is-expired last_upgrade_time +2 hours) ]; then
            upgrade
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

test() {
    echo '-----------------------------------'
    echo hello, jop v$(jop-ver)
    echo '-----------------------------------'
    echo cur_dir: $cur_dir
    echo cur_fie: $cur_file
    echo conf_file: $conf_file
}
