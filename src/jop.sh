#!/bin/bash

jop-init() {
  file-new $conf_file
  notes_dir=$(conf-get notes_dir)

  while [ "$notes_dir" = "" ]; do
      read -p "please set notes_dir: " notes_dir
      conf-set notes_dir $notes_dir
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
    conf-set notes_dir ''
    notes_dir=
    jop-init
}

jop-sync() {
    cd $notes_dir
    git-sync
    local git_orphan=$(conf-get git_orphan 0)
    if [ "$git_orphan" == "1" ]; then
        git-orphan
    fi
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
