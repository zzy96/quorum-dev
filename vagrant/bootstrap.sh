#!/bin/bash
set -eu -o pipefail

# install build deps
add-apt-repository ppa:ethereum/ethereum
add-apt-repository ppa:ubuntu-elisp/ppa
apt-get update
apt-get install -y build-essential libssl-dev unzip libdb-dev libleveldb-dev libsodium-dev zlib1g-dev libtinfo-dev solc sysvbanner wrk zsh software-properties-common haskell-platform emacs default-jdk maven

# install node/npm
curl -sL https://deb.nodesource.com/setup_8.x | bash -
apt-get install -y nodejs

export HOME=/home/vagrant
# this is the share folder
cd src

# install golang
GOREL=go1.10.3.linux-amd64.tar.gz
wget -q https://dl.google.com/go/$GOREL
tar xfz $GOREL
mv go /usr/local/go
rm -f $GOREL
export PATH=$PATH:/usr/local/go/bin

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

# clone repos
cd $HOME
git clone https://github.com/jpmorganchase/quorum.git
cd quorum
git remote add upstream https://github.com/jpmorganchase/quorum.git
echo 'export PATH=$PATH:$HOME/quorum/build/bin' >> $HOME/.zshrc

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
mv quorum-examples/examples/7nodes 7nodes
rm -rf quorum-examples

# install tessera
cd $HOME
wget -q https://github.com/jpmorganchase/tessera/releases/download/tessera-0.6/tessera-app-0.6-app.jar
mkdir -p tessera
cp ./tessera-app-0.6-app.jar tessera/tessera.jar
echo 'export TESSERA_JAR=$HOME/tessera/tessera.jar' >> $HOME/.zshrc

chown -R vagrant:vagrant $HOME

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

# web ui
cd $HOME
git clone https://github.com/cubedro/eth-netstats
cd eth-netstats
npm install
npm install -g grunt-cli
grunt
echo 'export WS_SECRET=123' >> $HOME/.zshrc

# done!
banner "Quorum Dev Box"
echo
echo 'The Quorum vagrant instance has been provisioned.'
echo "Use 'vagrant ssh' to open a terminal, 'vagrant suspend' to stop the instance, and 'vagrant destroy' to remove it."
