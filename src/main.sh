#!/bin/bash

main() {
  cmd=$1
  shift

  if [ "$cmd" == "reinit" ]; then
    jop-reinit $*
  else
      jop-init
      cd $notes_dir

      if [[ -z "$cmd" || "$cmd" == "main" ]]; then
          jop-sync
      elif [ "$(type -t jop-$cmd)" == function ]; then
          jop-$cmd $*
      elif [[ "$(type -t $cmd)" == function || $(which $cmd) != "" ]]; then
          $cmd $*
      elif [ -z $1 ]; then
          conf-get $cmd
      else
          conf-set $cmd $1
      fi
  fi
}

upgrade() {
    echo upgrading jop...
    echo " "
    cd $cur_dir
    git-sync
}
