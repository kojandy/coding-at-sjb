#!/bin/sh
# https://www.drewsilcock.co.uk/compiling-zsh

INSTALL_DIR=$HOME/.local
TEMP_DIR=$(mktemp -d)

# ncurses

cd $TEMP_DIR
wget https://ftp.gnu.org/pub/gnu/ncurses/ncurses-6.2.tar.gz
tar -xf ncurses-6.2.tar.gz
cd ncurses-6.2

export CXXFLAGS=' -fPIC'
export CFLAGS=' -fPIC'

./configure --prefix=$INSTALL_DIR --enable-shared

make
make install

# zsh

cd $TEMP_DIR
git clone --depth 1 https://github.com/zsh-users/zsh
cd zsh

export PATH=$INSTALL_DIR/bin:$PATH
export LD_LIBRARY_PATH=$INSTALL_DIR/lib:$LD_LIBRARY_PATH
export CFLAGS=-I$INSTALL_DIR/include
export CPPFLAGS="-I$INSTALL_DIR/include" LDFLAGS="-L$INSTALL_DIR/lib"

autoheader
autoconf
./configure --prefix=$INSTALL_DIR --enable-shared

make
make install
