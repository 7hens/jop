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
  notes_dir=$(jop-get notes_dir)

  while [ "$notes_dir" = "" ]; do
      read -p "please set notes_dir: " notes_dir
      jop-set notes_dir $notes_dir
  done

  while [ ! -d "$notes_dir/.git" ]; do
      local remote_url=
      while [ "$remote_url" = "" ]; do
          read -p "please set remote_url: " remote_url
      done
      git clone $remote_url $notes_dir
  done

  if [ -d "$notes_dir" ]; then
      mkdir -p $notes_dir/locks
  fi
}

jop-reinit() {
    notes_dir=
    jop-set notes_dir $notes_dir
    jop-init
}

jop-sync() {
    cd $notes_dir
    git-sync
    local git_orphan=$(jop-get git_orphan 0)
    if [ "$git_orphan" == "1" ]; then
        git-orphan
    fi
}

jop-interval() {
    local sync_interval=$(test -n "$1" && echo $1 || echo 5m)
    local should_sync=1
    while true; do
        local last_changed_time=$(git-last-changed-time 2> /dev/null)
        if [[ $? == 0 && -n "$last_changed_time" ]]; then
            local remaining_time="+5 minutes"
            local expired_timestamp=$(os-x date -d "$last_changed_time $remaining_time" +%s)
            # echo $last_changed_time / $(date +%s), $expired_timestamp
            if [ $(date +%s) -le $expired_timestamp ]; then
                should_sync=0
            fi
        fi
        test "$should_sync" == 1 && git-sync
        os-x sleep $sync_interval
    done
}

# jop-start() {
#     # nohup jop-interval > /dev/null 2> /dev/null &
#     jop-interval > /dev/null 2> /dev/null
# }

# jop-stop() {
#     local jop_task=$(jop-task)
#     test -n "$jop_task" && kill $jop_task
#     jop-set is_interval_started 0
# }

# jop-task() {
#     jobs -l | grep jop | awk '{print $2}'
# }

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