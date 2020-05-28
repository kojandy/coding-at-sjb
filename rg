#!/bin/sh

TEMP_DIR=$(mktemp -d)
cd $TEMP_DIR
wget 'https://github.com/BurntSushi/ripgrep/releases/download/12.1.0/ripgrep-12.1.0-x86_64-unknown-linux-musl.tar.gz'
tar -xf 'ripgrep-12.1.0-x86_64-unknown-linux-musl.tar.gz' -C /tmp/sjb/local/bin --strip-components=1 'ripgrep-12.1.0-x86_64-unknown-linux-musl/rg'
rm -rf $TEMP_DIR
