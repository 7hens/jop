#!/bin/bash

jop-test() {
    echo '-----------------------------------'
    echo hello, jop v$(jop-ver)
    echo '-----------------------------------'
    echo cur_dir: $cur_dir
    echo cur_fie: $cur_file
    echo conf_file: $conf_file
}

jop-init() {
  file-new $conf_file
  file-new $remote_conf_file
  repo_dir=$(jop-get repo_dir)
  notes_dir="$repo_dir/$(jop-get notes_dir)"

  while [ "$repo_dir" = "" ]; do
      read -p "please set repo_dir: " repo_dir
      jop-set repo_dir $repo_dir
  done

  while [ ! -d "$repo_dir/.git" ]; do
      local remote_url=
      while [ "$remote_url" = "" ]; do
          read -p "please set remote_url: " remote_url
      done
      git clone $remote_url $repo_dir
  done
  jop-fix
}

jop-reinit() {
    repo_dir=
    jop-set repo_dir $repo_dir
    jop-init
}

jop-fix() {
  if [ -d "$notes_dir" ]; then
      mkdir -p $notes_dir/locks
  fi
}

jop-sync() {
    cd $repo_dir
    echo -e "\033[32msync at $(date) \033[m..."
    git-sync
    local git_orphan=$(jop-get git_orphan 0)
    if [ "$git_orphan" == "1" ]; then
        git-orphan
    fi
    jop-fix
}

jop-interval() {
    local sync_interval=$(test -n "$1" && echo $1 || echo 5m)
    local should_sync=1
    while true; do
        should_sync=1
        local last_changed_time=$(git-last-changed-time 2> /dev/null)
        if [[ $? == 0 && -n "$last_changed_time" ]]; then
            local remaining_time="+5 minutes"
            local expired_timestamp=$(os-x date -d "$last_changed_time $remaining_time" +%s)
            # echo $last_changed_time / $(date +%s), $expired_timestamp
            if [ $(date +%s) -le $expired_timestamp ]; then
                should_sync=0
            fi
        fi
        test "$should_sync" == 1 && jop-sync
        os-x sleep $sync_interval
    done
}

jop-start() {
    jop-stop
    local task_pid=$(jop-interval > /dev/null 2> /dev/null & echo $!)
    jop-set task_pid $task_pid
}

jop-stop() {
    local task_pid=$(jop-get task_pid)
    test -n "$task_pid" \
        && test -n "$(ps -ef | grep jop | grep $task_pid)" \
        && kill $task_pid
    jop-set task_pid
}

jop-upgrade() {
    if [ $(jop-ver -r) -lt $(jop-ver) ]; then
        return
    fi
    echo upgrading jop...
    echo " "
    cd $cur_dir
    git-sync
    jop-set last_upgrade_time "$(date)"
}

jop-edit() {
    code $cur_dir/
}

jop-res-del() {
    local res_id=$1
    if [ -z $res_id ]; then
        echo "ERROR: a resource id is required" 1>&2
        return 1
    fi
    sqlite3 ~/.config/joplin-desktop/database.sqlite "delete from resources where id = '$res_id'"
    echo ok, please restart your joplin app to check it out
}

jop-replace() {
    local origin=$1
    local dest=$2
    if [ -z "$origin" ]; then
        return 0
    fi
    cd ~/.config/joplin-desktop
    ls edit-*.md | xargs sed -i'' -e "s#$origin#$dest#g"
}