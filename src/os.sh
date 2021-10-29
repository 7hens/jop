#!/bin/bash

os-env() {
  local unameOut="$(uname -s)"
  local machine=
  case "${unameOut}" in
      Linux*)     machine=Linux;;
      Darwin*)    machine=Mac;;
      CYGWIN*)    machine=Cygwin;;
      MINGW*)     machine=MinGw;;
      *)          machine="UNKNOWN:${unameOut}"
  esac
  echo ${machine}
}

os-name() {
  local unameOut="$(uname -s)"
  local machine=
  case "${unameOut}" in
      Linux*)     machine=Linux;;
      Darwin*)    machine=Mac;;
      CYGWIN*)    machine=Windows;;
      MINGW*)     machine=Windows;;
      *)          machine="UNKNOWN:${unameOut}"
  esac
  echo ${machine}
}

is-mac() {
    test $(os-name) = Mac
    return $?
}

os-x() {
    local cmd=$1
    shift
    if $(is-mac && which "g$cmd" > /dev/null); then
        g$cmd "$@"
    else
        $cmd "$@"
    fi
}

os-kill() {
  local task_name=$1
  if [ $(os-name) == Windows ]; then
    batch-begin
    tasklist | grep $task_name | awk '{print $2}' | xargs taskkill /F /T /PID
    batch-end
    # cmd -/c "TASKKILL /F /IM $task_name /T"
  else
    ps -ef | grep $task_name | awk '{print $2}' | xargs kill
  fi
}
