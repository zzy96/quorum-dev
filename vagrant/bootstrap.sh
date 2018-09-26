#!/bin/bash
set -eu -o pipefail

# install build deps
add-apt-repository ppa:ethereum/ethereum
add-apt-repository ppa:ubuntu-elisp/ppa
apt-get update
apt-get install -y build-essential unzip libdb-dev libleveldb-dev libsodium-dev zlib1g-dev libtinfo-dev solc sysvbanner wrk zsh software-properties-common haskell-platform emacs default-jdk maven

export HOME=/home/vagrant
cd src

# install golang
GOREL=go1.9.3.linux-amd64.tar.gz
wget -q https://dl.google.com/go/$GOREL
tar xfz $GOREL
mv go /usr/local/go
rm -f $GOREL
export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/src/go
export PATH=$PATH:$GOPATH/bin

cd $HOME

# (optional) install zsh
chsh -s $(which zsh)
echo 'export SHELL=/bin/zsh' >> .bash_profile
echo 'exec /bin/zsh -l' >> .bash_profile
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
curl -L git.io/antigen > antigen.zsh # install antigen
cp /vagrant/.zshrc $HOME/.zshrc
git clone https://github.com/zsh-users/zsh-autosuggestions $HOME/.zsh/zsh-autosuggestions # plugin

# setting env var in zsh
echo 'export PATH=$PATH:/usr/local/go/bin' >> $HOME/.zshrc
echo 'export GOPATH=$HOME/src/go' >> $HOME/.zshrc
echo 'export PATH=$PATH:$GOPATH/bin' >> $HOME/.zshrc

# clone repos
git clone https://github.com/jpmorganchase/quorum.git $GOPATH/src/github.com/ethereum/go-ethereum
cd $GOPATH/src/github.com/ethereum/go-ethereum
git remote add upstream https://github.com/jpmorganchase/quorum.git
cd $HOME

git clone https://github.com/jpmorganchase/constellation.git
cd constellation
git remote add upstream https://github.com/jpmorganchase/constellation.git
cd $HOME

git clone https://github.com/jpmorganchase/quorum-tools.git
cd quorum-tools
git remote add upstream https://github.com/jpmorganchase/quorum-tools.git
cd $HOME

git clone https://github.com/jpmorganchase/quorum-examples.git

# install geth dependencies
cd $GOPATH/src/github.com/ethereum/go-ethereum
go install -v ./...

# install tessera
wget -q https://github.com/jpmorganchase/tessera/releases/download/tessera-0.6/tessera-app-0.6-app.jar
mkdir -p /home/vagrant/tessera
cp ./tessera-app-0.6-app.jar /home/vagrant/tessera/tessera.jar
echo "TESSERA_JAR=/home/vagrant/tessera/tessera.jar" >> $HOME/.zshrc

chown -R vagrant:vagrant $HOME/quorum-tools $HOME/quorum-examples $HOME/constellation $HOME/tessera $GOPATH

# (optional) install spacemacs
# git clone https://github.com/syl20bnr/spacemacs $HOME/.emacs.d
# git clone https://github.com/Szkered/dotfiles
# ln -s dotfiles/.spacemacs $HOME/.spacemacs

# (optional) install go-mode tools
# go get -u -v github.com/nsf/gocode
# go get -u -v github.com/rogpeppe/godef
# go get -u -v golang.org/x/tools/cmd/guru
# go get -u -v golang.org/x/tools/cmd/gorename
# go get -u -v golang.org/x/tools/cmd/goimports
# go get -u -v github.com/alecthomas/gometalinter
# gometalinter --install --update

# done!
banner "Quorum Dev Box"
echo
echo 'The Quorum vagrant instance has been provisioned.'
echo "Use 'vagrant ssh' to open a terminal, 'vagrant suspend' to stop the instance, and 'vagrant destroy' to remove it."
