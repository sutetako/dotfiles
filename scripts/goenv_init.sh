export GOENV_ROOT="$HOME/.goenv"
export GOPATH="$HOME/go"
export GOENV_DISABLE_GOPATH=1
# export GO111MODULE=on
export PATH="$GOPATH/bin:$GOENV_ROOT/bin:$PATH"
eval "$(goenv init -)"
