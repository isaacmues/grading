#!/bin/bash

# This can be better
function usage {
    echo "Prepare"
    echo "-------"
    echo
    echo "OPTIONS"
    echo
    echo "  -h"
    echo "      shows usage"
    echo "  -l"
    echo "      csv file with students names"
    echo "  -d"
    echo "      directory where the homework is"
    echo "  -n"
    echo "      number of problems"
}

function get_name {
    name=$(echo $1 | grep -e '-[a-z_]\+-' -o)
    name=$(grep ${name:1:-1} $2 | cut -d , -f 2)
}

optstring="d:l:n:h"

while getopts ${optstring} arg; do
    case ${arg} in
        h)
            echo "Showing usage"
            usage
            ;;
        l)
            list=${OPTARG}
            echo "List at $list"
            ;;
        d)
            hwdir=${OPTARG}
            echo "Homework at $hwdir"
            ;;
        n)
            n=${OPTARG}
            echo "Number of problems $n"
    esac
done

# TODO put an if to check if the non-optional options are valid
for hw in "$hwdir"tarea*.pdf
do
    echo $hw
done

