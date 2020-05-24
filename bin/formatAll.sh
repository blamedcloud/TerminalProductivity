#!/bin/bash

formatPrefix="format_"

# first argument should be the path/to/file to format
# second argument is a folder to put formatted file in
formatFile() {
    local fileName=$1
    local outputDir=$2
    if [[ ("$fileName" == *".xml") && ("$fileName" != *"pom.xml") ]]
    then
        local base=$(basename $fileName)
        local newFile="${outputDir}/${formatPrefix}${base}"
        xmllint --format $fileName > $newFile
    elif [[ "$fileName" == *".json" ]]
    then
        local base=$(basename $fileName)
        local newFile="${outputDir}/${formatPrefix}${base}"
        python -m json.tool $fileName > $newFile
    fi
}

formatDir=
outputDir=
if [ $# -eq 1 ] && [ -d "$1" ]
then
    formatDir=$1
    outputDir=$1
elif [ $# -eq 2 ] && [ -d "$1" ] && [ -d "$2" ]
then
    formatDir=$1
    outputDir=$2
elif [ $# -eq 1 ] && [ -f "$1" ]
then
    formatFile $1 $(dirname $1)
    exit 0
elif [ $# -eq 2 ] && [ -f "$1" ] && [ -d "$2" ]
then
    formatFile $1 $2
    exit 0
elif [ $# -eq 0 ]
then
    formatDir=$(pwd)
    outputDir=$formatDir
else
    echo "First argument must be a directory or a file"
    exit 1
fi

for fileName in $formatDir/*
do
    if [[ "$(basename $fileName)" != "$formatPrefix"* ]]
    then
        formatFile $fileName $outputDir
    fi
done
