TEMP_DIR=$(mktemp -d)
SJB_HOME=/tmp/sjb

mkdir -p $SJB_HOME/local

# install zsh
wget -O $TEMP_DIR/zsh.tar.gz 'https://github.com/kojandy/coding-at-sjb/releases/download/20.05.1/zsh.tar.gz'
tar -xf $TEMP_DIR/zsh.tar.gz -C $SJB_HOME/local

# install autojump
cd $TEMP_DIR
git clone --depth 1 https://github.com/wting/autojump
cd autojump
./install.py

# install node
wget -O $TEMP_DIR/node-v12.16.3-linux-x64.tar.gz 'https://nodejs.org/dist/v12.16.3/node-v12.16.3-linux-x64.tar.xz'
tar -xf $TEMP_DIR/node-v12.16.3-linux-x64.tar.gz --strip-components=1 -C $SJB_HOME/local

# install dotfiles
DOTFILES=$HOME/.dotfiles
XDG_CONFIG_HOME=$HOME/.config
git clone --depth 1 https://github.com/kojandy/.dotfiles $DOTFILES
$DOTFILES/install/zgen
ln -sf $DOTFILES/profile $HOME/.profile
ln -sf $DOTFILES/vim/vimrc $HOME/.vimrc
ln -sf $DOTFILES/zsh/zshrc $HOME/.zshrc
mkdir -p $XDG_CONFIG_HOME/git
ln -sf $DOTFILES/git/config $XDG_CONFIG_HOME/git/config
ln -sf $DOTFILES/git/ignore $XDG_CONFIG_HOME/git/ignore

# install st
wget -O $SJB_HOME/local/bin/st 'https://github.com/kojandy/st/releases/download/20.05.1/st'
chmod +x $SJB_HOME/local/bin/st

# map caps lock to control
echo "remove Lock = Caps_Lock
keysym Caps_Lock = Control_L
add Control = Control_L" > $HOME/.xmodmap
xmodmap $HOME/.xmodmap

# set terminal keyboard shortcut
echo "[custom-keybindings/custom0]
binding=['<Super>Return']
command='$SJB_HOME/local/bin/st -e $SJB_HOME/local/bin/zsh'
name='st'
[/]
custom-list=['custom0']" | dconf load /org/cinnamon/desktop/keybindings/

# set path
echo "export PATH=$SJB_HOME/local/bin:$PATH" > $HOME/.zshrc.local

# clean up
rm -rf $TEMP_DIR
