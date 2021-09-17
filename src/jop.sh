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
