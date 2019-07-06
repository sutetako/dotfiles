# copy to root directory of vim project
LDFLAGS="-Wl,-rpath=${HOME}/.pyenv/versions/${PY_VERSION}/lib" ./configure --with-features=huge --enable-gui=gtk3 --enable-perlinterp --enable-python3interp --enable-luainterp --with-luajit --enable-fail-if-missing
