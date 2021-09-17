#!/bin/bash

file-new() {
    local file=$1
    if [ ! -e "$file" ]; then
        mkdir -p $(dirname $file)
        touch $file
    fi
}

file-link() {
    local file=$1
    echo $(dir-link $file)/$(basename $file)
}

dir-link() {
    local file=$1
    cd $(dirname $file) > /dev/null
    pwd
}

file-mkx() {
    local source=$(file-link $1)
    local dest=~/$(basename $1)
    echo -e "#!/bin/bash\n\n. $source" > $dest
    chmod +x $dest
}
