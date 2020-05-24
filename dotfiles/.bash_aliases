#!/bin/bash

### Functions ###
send_keys_all_panes() {
    local _pane
    for _pane in $(tmux list-panes -F '#P')
    do
        tmux send-keys -t ${_pane} "$@"
    done
}

skap() {
    send_keys_all_panes "$@"
}

scap() {
    send_keys_all_panes "$@" Enter
}

send_keys_all_windows() {
    local _window
    local _pane
    for _window in $(tmux list-windows -F '#I')
    do
        for _pane in $(tmux list-panes -t ${_window} -F '#P')
        do
            tmux send-keys -t ${_window}.${_pane} "$@"
        done
    done
}

skaw() {
    send_keys_all_windows "$@"
}

scaw() {
    send_keys_all_windows "$@" Enter
}

send_keys_all_sessions() {
    local _session
    local _window
    local _pane
    for _session in $(tmux list-sessions -F '#S')
    do
        for _window in $(tmux list-windows -t ${_session} -F '#I')
        do
            for _pane in $(tmux list-panes -t ${_session}:${_window} -F '#P')
            do
                tmux send-keys -t ${_session}:${_window}.${_pane} "$@"
            done
        done
    done
}

skas() {
    send_keys_all_sessions "$@"
}

scas() {
    send_keys_all_sessions "$@" Enter
}

update_brc_all_sessions() {
    skas C-z
    scas brc
# choose fgcls to clear the screen, or fgc to only check for fg
    scas fgc
    #scas fgcls
}

cdgithead() {
    local repoFull=$(git rev-parse --show-toplevel 2> /dev/null)
    if [ -n "$repoFull" ]
    then
        cd $repoFull
    fi
}

cdabovesrctarget() {
    if [[ $(pwd) == *"/src/"* ]]
    then
        cd $(pwd | awk -F 'src' '{print $1}')
    elif [[ $(pwd) == *"/target/"* ]]
    then
        cd $(pwd | awk -F 'target' '{print $1}')
    fi
}

toggleprompt() {
    promptPathToggle.sh "$@" && source ~/.bashrc
}

docker_all() {
    docker images
    docker ps -a
}

git_show_commit_changes() {
    if [ $# -eq 0 ]
    then
        git diff-tree --no-commit-id --name-status -r HEAD
    else
        git diff-tree --no-commit-id --name-status -r "$@"
    fi
}

jsonformat() {
    if [ $# -ne 1 ]
    then
        exit 1
    fi
    if [ -f "$1" ]
    then
        python -m json.tool $1
    else
        echo "$1" | python -m json.tool
    fi
}

masterpull() {
    local branch=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')

    if [ "$branch" = "master" ]
    then
        # on a git branch, so no need for /dev/null redirect
        local canpull=$(git status | grep "Your branch is behind" | grep "and can be fast-forwarded." | wc -l)
        if [ $canpull -eq 1 ]
        then
            local shouldpull=$(git status | grep "nothing to commit, working directory clean" | wc -l)
            if [ $shouldpull -eq 1 ]
            then
                git pull
                git status
            fi
        fi
    fi
}

### Aliases ###
alias brc='source ~/.bashrc'

alias gfs='git fetch --all; git status'
alias gfbs='git fetch --all; git branch; git status'
alias gfbsp='git fetch --all; git branch; git status; masterpull'
alias gscc='git_show_commit_changes'

alias fgc='[ -n "$(jobs)" ] && fg'
alias fgcls='if [ -n "$(jobs)" ] ; then fg ; else clear ; fi'

alias tmuxbrc='update_brc_all_sessions'

# this alias ends with a space so that it can interpret other aliases after it.
alias mywatch='watch bash -i -c '

