#!/bin/bash
set -eu -o pipefail

# install build deps
add-apt-repository ppa:ethereum/ethereum
apt-get update
apt-get install -y build-essential unzip libdb-dev libleveldb-dev libsodium-dev zlib1g-dev libtinfo-dev solc sysvbanner wrk haskell-platform
#apt-get install -y zsh emacs25

export VAGRANTHOME=/vagrant

# install golang
GOREL=go1.9.3.linux-amd64.tar.gz
wget -q https://dl.google.com/go/$GOREL
tar xfz $GOREL
mv go /usr/local/go
rm -f $GOREL
export PATH=$PATH:/usr/local/go/bin
export GOPATH=$VAGRANTHOME/go
export PATH=$PATH:$GOPATH/bin

# (optional) install zsh
# chsh -s $(which zsh)
# echo 'export SHELL=/bin/zsh' >> .bash_profile
# echo 'exec /bin/zsh -l' >> .bash_profile
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
# curl -L git.io/antigen > antigen.zsh # install antigen
# cp /vagrant/.zshrc $VAGRANTHOME/.zshrc
# git clone https://github.com/zsh-users/zsh-autosuggestions $VAGRANTHOME/.zsh/zsh-autosuggestions # plugin

# setting env var in zsh
echo 'export PATH=$PATH:/usr/local/go/bin' >> $VAGRANTHOME/.bash_profile
echo 'export GOPATH=/vagrant/go' >> $VAGRANTHOME/.bash_profile
echo 'export PATH=$PATH:$GOPATH/bin' >> $VAGRANTHOME/.bash_profile
echo 'cd /vagrant' >> $VAGRANTHOME/.bash_profile

# clone repos
git clone https://github.com/zzy96/quorum.git $GOPATH/src/github.com/ethereum/go-ethereum
cd $GOPATH/src/github.com/ethereum/go-ethereum
git remote add upstream https://github.com/jpmorganchase/quorum.git
cd $VAGRANTHOME

git clone https://github.com/jpmorganchase/constellation.git

git clone https://github.com/jpmorganchase/quorum-tools.git

git clone https://github.com/jpmorganchase/quorum-examples.git

# install geth dependencies
cd $GOPATH/src/github.com/ethereum/go-ethereum
go install -v ./...

chown -R vagrant:vagrant $VAGRANTHOME/quorum-tools $VAGRANTHOME/quorum-examples $VAGRANTHOME/constellation $GOPATH

# install haskell tools
curl -sSL https://get.haskellstack.org/ | sh  # stack

# (optional) install spacemacs
# git clone https://github.com/syl20bnr/spacemacs $VAGRANTHOME/.emacs.d
# git clone https://github.com/Szkered/dotfiles
# ln -s dotfiles/.spacemacs $VAGRANTHOME/.spacemacs

# (optional) install go-mode tools
# go get -u -v github.com/nsf/gocode
# go get -u -v github.com/rogpeppe/godef
# go get -u -v golang.org/x/tools/cmd/guru
# go get -u -v golang.org/x/tools/cmd/gorename
# go get -u -v golang.org/x/tools/cmd/goimports
# go get -u -v github.com/alecthomas/gometalinter
# gometalinter --install --update

source $VAGRANTHOME/.bash_profile

# done!
banner "Quorum Dev Box"
echo
echo 'The Quorum vagrant instance has been provisioned.'
echo "Use 'vagrant ssh' to open a terminal, 'vagrant suspend' to stop the instance, and 'vagrant destroy' to remove it."
