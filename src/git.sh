#!/bin/bash

git-pull() {
    git pull --no-edit --allow-unrelated-histories -X diff-algorithm=patience
    if [ $? != 0 ]; then
        git checkout --ours .
        git add .
        git commit -m "MERGE: $(date)"
    fi
}

git-sync() {
    git add .
    git commit -m "$(date)"
    git-pull
    git push
}

git-head-branch() {
    echo $(git rev-parse --abbrev-ref HEAD)
}

git-branch-m() {
    local new_branch=$1
    local old_branch=$(git-head-branch)
    git branch -m $new_branch
    git push origin -u $new_branch
    git push origin -d $old_branch
}

git-orphan() {
    local head_branch=$(git-head-branch)
    git checkout --orphan orphan-$head_branch
    git add .
    git commit -m "init project"
    git branch -D $head_branch
    git branch -m $head_branch
    git push -f origin $head_branch
}
