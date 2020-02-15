#!/bin/bash

set -eu

cd "$(dirname "${BASH_SOURCE[0]}")"
BASE=`pwd`

sudo apt update
sudo apt install -y curl wget gnupg2 build-essential git cmake lsb-release software-properties-common

git submodule sync
git submodule update -i --recursive

source $BASE/configs/ENVIRONMENTS

# install clang
wget https://apt.llvm.org/llvm.sh
chmod +x llvm.sh
sudo ./llvm.sh $CLANG_VER
sudo update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-$CLANG_VER 100
sudo update-alternatives --install /usr/bin/clang clang /usr/bin/clang-$CLANG_VER 100

# install python with pyenv
ln -fsn $BASE/.pyenv $HOME/
. $BASE/scripts/pyenv_init.sh
cat $BASE/scripts/pyenv_init.sh >> $HOME/.bashrc

sudo apt install -y libssl-dev libbz2-dev libz-dev libsqlite3-dev libreadline-dev
CONFIGURE_OPTS="--enable-shared" pyenv install $PY_VER
pyenv global $PY_VER

pip install --upgrade pip
pip install -r $BASE/configs/requirements.txt

# install go with goenv
mkdir .go
ln -fsn $BASE/.goenv $HOME/
. $BASE/scripts/goenv_init.sh
cat $BASE/scripts/goenv_init.sh >> $HOME/.bashrc
goenv install $GO_VER
goenv global $GO_VER
goenv rehash

# install vim
sudo apt install -y ncurses-dev lua5.1 liblua5.1-dev luajit libluajit-5.1-dev python-dev

git clone --depth 1 https://github.com/vim/vim.git
pushd vim

LDFLAGS="-Wl,-rpath=${HOME}/.pyenv/versions/${PY_VER}/lib" \
./configure \
  --with-features=huge \
  --enable-gui=gtk3 \
  --enable-luainterp \
  --with-luajit \
  --enable-fail-if-missing \
  --enable-pythoninterp \
  --enable-python3interp \
  --with-python3-command=python${PY_VER_SHORT} \
  --with-python3-config-dir=${HOME}/.pyenv/versions/${PY_VER}/lib/python${PY_VER_SHORT}/config-${PY_VER_SHORT}m-x86_64-linux-gnu
  vi_cv_path_python3=${HOME}/.pyenv/versions/${PY_VER}/bin/python${PY_VER_SHORT}

make && sudo make install
popd

ln -fsn $BASE/.vim $HOME/
ln -fsn $BASE/.vimrc $HOME/

# install binaries for vim plugins
## fzf (and ripgrep)
curl -LO https://github.com/BurntSushi/ripgrep/releases/download/11.0.1/ripgrep_11.0.1_amd64.deb
sudo dpkg -i ripgrep_11.0.1_amd64.deb

$BASE/.fzf/install --bin
echo '[ -f ~/.fzf.bash ] && source ~/.fzf.bash' >> $HOME/.bashrc
ln -fsn $BASE/.fzf $HOME/
ln -fsn $BASE/scripts/fzf.bash $HOME/.fzf.bash

## gutentags
sudo apt install -y ctags

## vim-go
vim -T dumb -c "set nomore" -c ":GoInstallBinaries" -c quit

## helptags
sudo vim -T dumb -c "set nomore" -c ":helptags ALL" -c quit

