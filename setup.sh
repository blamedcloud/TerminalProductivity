#!/bin/bash

# these could happen in either order
echo "Setting up LogInstall"
./setup_LogInstall.sh
echo "Setting up bin scripts"
./setup_bin.sh

# this must come after LogInstall is set up
echo "Setting up dotfiles"
./setup_dotfiles.sh
