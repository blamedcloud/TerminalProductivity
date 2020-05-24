#!/bin/bash

thisFolder=$(pwd)

# change this line if you want your repos to live elsewhere
reposFolder=~/repos

[ ! -d $reposFolder ] && mkdir $reposFolder

cd $reposFolder

if [ ! -d "LogInstall" ]
then
    git clone https://github.com/blamedcloud/LogInstall.git
fi

cd LogInstall
# this setup script shouldn't mess anything up if you've already ran it so might as well run it again
./setup_bin.sh

# run the actual script in case $HOME/bin isn't on the $PATH yet
cd bin
echo "Installing dependencies"
./log_install.sh $(cat $thisFolder/to_install.txt)

