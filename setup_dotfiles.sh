#!/bin/bash

# remove conflicting dotfiles
[ -f $HOME/.bash_aliases ] && rm $HOME/.bash_aliases
[ -f $HOME/.bash_prompt ]  && rm $HOME/.bash_prompt
[ -f $HOME/.vimrc ]        && rm $HOME/.vimrc
[ -f $HOME/.tmux.conf ]    && rm $HOME/.tmux.conf

thisDir=$(pwd)
# set up symlinks
ln -s $thisDir/dotfiles/.bash_aliases $HOME/.bash_aliases
ln -s $thisDir/dotfiles/.bash_prompt $HOME/.bash_prompt
ln -s $thisDir/dotfiles/.vimrc $HOME/.vimrc
ln -s $thisDir/dotfiles/.tmux.conf $HOME/.tmux.conf

# setup .bashrc

# check for aliases:
grep "\. ~/.bash_aliases" ~/.bashrc > /dev/null
if [ $? -ne 0 ]
then
    echo "" >> ~/.bashrc
    echo "# Alias definitions" >> ~/.bashrc
    echo "if [ -f ~/.bash_aliases ]; then" >> ~/.bashrc
    echo "    . ~/.bash_aliases" >> ~/.bashrc
    echo "fi" >> ~/.bashrc
fi

# create a bin folder if one doesn't exist
[ ! -d $HOME/bin ] && mkdir $HOME/bin

# check for adding bin to the PATH:
grep "PATH=" ~/.bashrc | grep "\$HOME/bin" > /dev/null
if [ $? -ne 0 ]
then
    echo "" >> ~/.bashrc
    echo "# set PATH so it includes user's private bin if it exists" >> ~/.bashrc
    echo "if [ -d \"\$HOME/bin\" ]; then" >> ~/.bashrc
    echo "    PATH=\"\$HOME/bin:\$PATH\"" >> ~/.bashrc
    echo "fi" >> ~/.bashrc
fi

# check for prompt:
grep "\. ~/.bash_prompt" ~/.bashrc > /dev/null
if [ $? -ne 0 ]
then
    # this one is trickier since it doesn't want to go at the end of the file
    if [ $(grep "unset color_prompt" ~/.bashrc | wc -l) -eq 1 ]
    then
        # grab the line number of the match
        lineNum=$(grep -n "unset color_prompt" ~/.bashrc | cut -d':' -f1)
        insertText="\n# setup personal prompt\nif [ -f ~/.bash_prompt ]; then\n    . ~/.bash_prompt\nfi"
        tempFile=$(mktemp)
        cp ~/.bashrc $tempFile
        awk -v insert="$insertText" "{print} NR==$lineNum{print insert}" $tempFile > ~/.bashrc
        rm $tempFile
    else
        echo "Prompt setup not as expected. Manual intervention required"
    fi
fi

# set up pathogen (github.com/tpope/vim-pathogen)
if [ ! -f ~/.vim/autoload/pathogen.vim ]
then
    mkdir -p ~/.vim/autoload ~/.vim/bundle
    curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
fi

# set up tabline.vim (github.com/mkitt/tabline.vim)
if [ ! -d ~/.vim/bundle/tabline.vim ]
then
    cd ~/.vim/bundle
    git clone git://github.com/mkitt/tabline.vim.git
fi

# set up vim clipboard capability
vimClip=$(vim --version | grep -e "-clipboard" | wc -l)
vimXtermClip=$(vim --version | grep -e "-xterm_clipboard" | wc -l)
if [ $vimClip -ne 0 ] || [ $vimXtermClip -ne 0 ]
then
    log_install.sh vim-gtk
fi

# set up tmux plugin manager (github.com/tmux-plugins/tpm)
if [ ! -d ~/.tmux/plugins/tpm ]
then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    echo "from within tmux use \"prefix + I\" to install plugins"
    echo "and \"prefix + U\" to update plugins"
fi

