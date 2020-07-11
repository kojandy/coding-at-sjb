#!/bin/bash
REPO_DIR=/tmp/sjb/repo
INSTALL_DIR=/tmp/sjb

repos='core extra community'
url='http://ftp.harukasan.org/archlinux/$repo/os/$arch'
url=${url/\$arch/x86_64}

setup() {
    rm -rf $REPO_DIR
    mkdir -p $REPO_DIR
    cd $REPO_DIR
    for repo in $repos
    do
        echo Making $repo db...
        mkdir $repo
        curl -# ${url/\$repo/$repo}/$repo.db | tar -C $repo -xz
        descs=$(find $repo -name desc -type f)
        total=$(echo $descs | wc -w)
        i=0
        for desc in $descs
        do
            name=$(cat $desc | sed -n '/%NAME%/{n;p}')
            filename=$(cat $desc | sed -n '/%FILENAME%/{n;p}')
            echo $name $filename >> $repo.db
            ((i++))
            echo -ne '\r' $i / $total
        done
        echo
        rm -rf $repo
    done
}

search() {
    for repo in $repos
    do
        grep $1 $REPO_DIR/$repo.db | sed 's/ .*//'
    done
}

db_search() {
    for repo in $repos
    do
        sed -n "/^$1 /p" $REPO_DIR/$repo.db | awk -v repo=$repo '{print $1 " " repo " " $2}'
    done
}

install() {
    TEMP_DIR=$(mktemp -d)
    target=$(db_search $1)

    if [ ! -z "$target" ]
    then
        repo=$(echo $target | awk '{print $2}')
        filename=$(echo $target | awk '{print $3}')
        url=${url/\$repo/$repo}/$filename
        case $filename in
            *.zst)
                curl $url | tar -C $TEMP_DIR -I zstd -x
                ;;
            *.xz)
                curl $url | tar -C $TEMP_DIR -xJ
                ;;
        esac
    else
        echo $1 not found!
    fi

    tree $TEMP_DIR
    rm -rf $TEMP_DIR
}

setup
