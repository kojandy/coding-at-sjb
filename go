#!/bin/sh

TEMP_DIR=$(mktemp -d)
mkdir -p /tmp/sjb/local

cd $TEMP_DIR
wget "https://dl.google.com/go/go1.14.3.linux-amd64.tar.gz"
tar -C /tmp/sjb/local --strip-components=1 -xf "go1.14.3.linux-amd64.tar.gz"
rm -rf $TEMP_DIR
