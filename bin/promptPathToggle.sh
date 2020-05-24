#!/bin/bash

togglePath=no
toggleGit=no

anyChange=no

while [ $# -gt 0 ]
do
    if [ "$1" = "-p" ]
    then
        togglePath=yes
        anyChange=yes
    elif [ "$1" = "-g" ]
    then
        toggleGit=yes
        anyChange=yes
    else
        echo "Invalid arg \"$1\", exiting"
        exit 1
    fi
    shift 1
done

if [ "$anyChange" = yes ]
then
    promptFile=$(readlink -f ~/.bash_prompt)
    mode=$(stat -c "%a" $promptFile)
    tempFile=$(mktemp)
    mv $promptFile $tempFile
    touch $promptFile
    chmod $mode $promptFile

    IFS=
    while read -r line
    do
        if [[ ("$togglePath" == "yes") && ("$line" == "#__prompt_path="*) ]]
        then
            echo "${line:1}" >> $promptFile
        elif [[ ("$togglePath" == "yes") && ("$line" == "__prompt_path="*) ]]
        then
            echo "#$line" >> $promptFile
        elif [[ ("$toggleGit" == "yes") && ("$line" == "#__git_prompt="*) ]]
        then
            echo "${line:1}" >> $promptFile
        elif [[ ("$toggleGit" == "yes") && ("$line" == "__git_prompt="*) ]]
        then
            echo "#$line" >> $promptFile
        else
            echo "$line" >> $promptFile
        fi
    done < $tempFile

    rm $tempFile
    exit 0
fi
exit 2
