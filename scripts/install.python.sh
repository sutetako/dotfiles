VERSION=3.7.3
sudo apt install libssl-dev libbz2-dev libz-dev libsqlite3-dev
ln -fsn $HOME/dotfiles/.pyenv $HOME/
cat pyenv_init.sh >> ~/.bashrc
. pyenv_init.sh
CONFIGURE_OPTS="--enable-shared" pyenv install $VERSION
pyenv global $VERSION
