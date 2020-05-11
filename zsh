#!/bin/sh

TEMP_DIR=$(mktemp -d)

cd $TEMP_DIR

wget 'https://github.com/kojandy/coding-at-sjb/releases/download/2020.05/zsh.tar.gz'
mkdir -p /tmp/sjb/local
tar -xf zsh.tar.gz -C /tmp/sjb/local

rm -rf $TEMP_DIR
