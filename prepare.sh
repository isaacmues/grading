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
    local name=$(echo $1 | grep -e '-[a-z_]\+.' -o)
    name=$(grep ${name:1:-1} $2 | cut -d , -f 2)
    echo $name
}

function get_number {
    local number=$(echo $1 | grep -e '_[0-9]\+-' -o)
    echo ${number:1:-1}
}

function make_title {
    local name=$(get_name $1 $2)
    local number=$(get_number $1)
    echo "Tarea $number de $name"
}

function make_table {
    
    echo "| Problema | Puntuación |"
    echo "| :------: | :--------: |"

    for ((i = 1 ; i <= $n ; i++))
    do
        echo "| $i | puntuacion_$i |"
    done

    echo "| **Total** | puntuacion_total |"
}

function make_commentaries_file {
    echo $1 | sed 's/.pdf/-commentaries.md/'
}

function create_template {

    echo "# $(make_title $1 $2)"
    echo "## Calificación: xcalificacionx"
    echo "---"
    echo ""
    echo "## Resumen"
    echo ""
    make_table $3
    echo ""
    echo "## Comentarios"
    echo ""

    for ((i = 1 ; i <= $n ; i++))
    do
        echo "$i. **(x pts)**"
    done

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
    commentaries=$(make_commentaries_file $hw)
    create_template $hw $list $n >> $commentaries
done

