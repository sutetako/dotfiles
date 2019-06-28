VERSION=3.7.3
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> $HOME/.bashrc
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> $HOME/.bashrc
echo 'export PY_VERSION="$VERSION"' >> $HOME/.bashrc
echo 'eval "$(pyenv init -)"' >> $HOME/.bashrc
source $HOME/.bashrc
CONFIGURE_OPTS="--enable-shared" pyenv install $VERSION
pyenv global $VERSION
