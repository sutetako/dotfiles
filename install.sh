#!/bin/bash

set -eu

cd "$(dirname "${BASH_SOURCE[0]}")"
BASE=`pwd`

sudo apt update
DEBIAN_FRONTEND=noninteractive sudo -E apt install -y curl wget gnupg2 build-essential git cmake lsb-release software-properties-common

git submodule sync
git submodule update -i --recursive

source $BASE/configs/lang_ver

# install clang (latest stable)
wget https://apt.llvm.org/llvm.sh -O llvm.sh
chmod +x llvm.sh
sudo ./llvm.sh $CLANG_VER
sudo update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-$CLANG_VER 100
sudo update-alternatives --install /usr/bin/clang clang /usr/bin/clang-$CLANG_VER 100
sudo update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-$CLANG_VER 100

sudo apt install -y libssl-dev libbz2-dev libz-dev libsqlite3-dev libreadline-dev python3 python3-pip python3-dev python-is-python3

# install go
rm -rf go && curl -sL https://go.dev/dl/go${GO_VER}.linux-amd64.tar.gz | tar -C ./ -xz

cat $BASE/scripts/go_init.sh >> $HOME/.bash_profile
echo "export PATH=$PATH:$BASE/go/bin" >> $HOME/.bash_profile
. $HOME/.bash_profile

## install vim
sudo apt install -y libncurses-dev lua5.4 liblua5.4-dev luajit libluajit-5.1-dev libx11-dev libxt-dev python3-dev
rm -rf vim && git clone --depth 1 https://github.com/vim/vim.git -b v9.1.0821
pushd vim

./configure \
  --prefix=$BASE/.vim \
  --enable-fail-if-missing \
  --enable-luainterp=dynamic \
  --enable-multibyte \
  --enable-python3interp=dynamic \
  --with-features=huge \
  --with-luajit \
  --with-x

make -j8 && sudo make install
sudo update-alternatives --install /usr/bin/vi vi $BASE/.vim/bin/vim 100
sudo update-alternatives --install /usr/bin/vim vim $BASE/.vim/bin/vim 100
sudo update-alternatives --install /usr/bin/editor editor $BASE/.vim/bin/vim 100
popd

ln -fsn $BASE/.vim $HOME/
ln -fsn $BASE/.vimrc $HOME/
ln -fsn $BASE/.lsp_servers $HOME/.lsp_servers

# apply legacy colors
git clone --depth 1 https://github.com/vim/colorschemes.git
cp -r colorschemes/legacy_colors/* $BASE/.vim/colors/ && rm -rf colorschemes

# install binaries for vim plugins
## fzf (and ripgrep)
sudo apt install ripgrep

$BASE/.fzf/install --bin
echo '[ -f ~/.fzf.bash ] && source ~/.fzf.bash' >> $HOME/.bashrc
ln -fsn $BASE/.fzf $HOME/
ln -fsn $BASE/scripts/fzf.bash $HOME/.fzf.bash

## gutentags
sudo apt install -y universal-ctags

## vim-go
vim -T dumb -c "set nomore" -c ":GoInstallBinaries" -c quit

# helptags
sudo vim -T dumb -c "set nomore" -c ":helptags ALL" -c quit

