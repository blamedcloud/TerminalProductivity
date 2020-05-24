# TerminalProductivity
A collection of references, scritps, and config files to enhance productivity in a terminal environment.

### Setup:

Clone this repo to wherever you want it on your new system.

Right now, there isn't really much configuration for a piecemeal installation, so if you don't want everything you may feel inclined to look at the setup\*.sh files to see what they do.

Some things you may want to be aware of:
1. In setup\_LogInstall.sh it will install LogInstall (github.com/blamedcloud/LogInstall) into ~/repos unless you feel like changing the install location
2. setup\_dotfiles.sh will make changes to your .bashrc
3. setup\_dotfiles.sh will install some vim and tmux plugins
4. The setup process will delete files it's about to symlink:
    * ~/.vimrc
    * ~/.tmux.conf
    * ~/.bash\_aliases
    * ~/.bash\_prompt (as far as I know this isn't a standard file so this should be file)
    * files in ~/bin that share a name with files in TerminalProductivity/bin
    * files in ~/bin that share a name with files in LogInstall/bin

If none of that bothers you, then go ahead and run the setup script:

    $ cd /path/to/TerminalProductivity
    $ ./setup.sh

Alternatively, you could run the other setup scripts individually if you want. However, you should be aware that setup\_dotfiles.sh must come after setup\_LogInstall.sh as it tries to use LogInstall at one point.

Disclaimer: I've only tested this on ubuntu-like systems that use bash as the primary shell. If you use another environment, proceed with caution.
