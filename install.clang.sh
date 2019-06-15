sudo echo "deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-8 main" >> /etc/apt/sources.list.d/clang.list
sudo echo "deb-src http://apt.llvm.org/xenial/ llvm-toolchain-xenial-8 main" >> /etc/apt/sources.list.d/clang.list
wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key|sudo apt-key add -
sudo apt update && sudo apt install  clang-8 lldb-8 lld-8 clang-tools-8
sudo update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-8 100
sudo update-alternatives --install /usr/bin/clang clang /usr/bin/clang-8 100

