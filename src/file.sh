#!/bin/bash

file-new() {
    local file=$1
    if [ ! -e "$file" ]; then
        mkdir -p $(dirname $file)
        touch $file
    fi
}
