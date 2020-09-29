#!/bin/bash

sudo apt-get update
sudo apt-get -y dist-upgrade
sudo apt-get install -y parallel dns-utils libevent ncurses libevent-dev ncurses-dev build-essential bison pkg-config wget curl vim mc

wget https://github.com/tmux/tmux/releases/download/3.1b/tmux-3.1b.tar.gz
tar -zxf tmux-*.tar.gz
cd tmux-*/
./configure
make && sudo make install
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
cd -

cp ssh_autocomplete.sh /etc/bash_completion.d/ssh
