#!/bin/bash

if [ $# -eq 2 ] && [ -d "$1" ] && [ -d "$2" ]
then
    git diff --no-index "$1" "$2"
else
    echo "Incorrect arguments"
    echo "requires two directories as args"
    exit 1
fi
