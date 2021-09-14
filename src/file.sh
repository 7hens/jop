#!/bin/bash

file-replace() {
    local file=$1
    local key=$2
    local value=$3
    if [ "$os" == "Darwin" ]; then
        sed -i '' "s#^$key=.*\$#$key=$value#g" $file
    else
        sed -i "s#^$key=.*\$#$key=$value#g" $file
    fi
}

file-new() {
    local file=$1
    if [ ! -e "$file" ]; then
        mkdir -p $(dirname $file)
        touch $file
    fi
}
