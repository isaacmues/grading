#!/bin/bash

#grade (){
#    name=$(echo $1 | grep -e '-[a-z_]\+-' -o)
#    name=$(grep ${name:1:-1} $2 | cut -d , -f 2)
#    hw_number=$(echo $1 | grep -e '_[0-9]\+-' -o)
#    hw_number=${hw_number:1:-1}
#    points=$(grep -e '([0-9.]\+ pts)' -o $1 | grep -e '[0-9.]\+' -o)
#    total=$(echo $points | sed -e 's/ /\+/g' | bc -l)
#    m=$(echo $points | wc -w)
#    grade=$(echo "scale=1; $total * 10 / $m" | bc -l)
#    n=0
#
#    echo "# Tarea $hw_number de $name"
#    echo "## Calificación: $grade" 
#    echo -e "\n---\n" 
#    echo -e "## Resumen\n" 
#    echo "| Ejercicio | Puntuación |" 
#    echo "| :-------: | :--------: |" 
#
#    for p in $points
#    do
#        n=$((n + 1))
#        echo "| $n | $p |" 
#    done
#
#    echo "| **Total** | $total |" 
#    echo -e "\n## Comentarios\n" 
#    cat $1
#    echo -e "\n"
#}

comments_to_pdf(){
    local comments_pdf=$(echo $1 | sed 's/.md/.pdf/')
    pandoc -o $comments_pdf $1
}

make_final_pdf(){
    local source_pdf=$(echo $1 | sed 's/-commentaries.md/.pdf/')
    local comments_pdf=$(echo $1 | sed 's/.md/.pdf/')
    local final_pdf=$(echo $1 | sed 's/commentaries.md/calificada.pdf/')
    pdfunite $comments_pdf $source_pdf $final_pdf
    rm $comments_pdf
}

function usage {
    echo "Grading script"
    echo "=============="
    echo "grade -l students_list -d homework_directory"
}

optstring="d:l:h"

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
    esac
done

function get_scores {
    local scores=()

    for s in $(grep -e '[01].[0-9]\{1,2\} pts' -o -h $1)
    do
        if [[ "$s" != "pts" ]]; then
            scores+=("$s")
        fi
    done

    echo ${scores[@]}
}

function get_total {
    get_scores $1 | sed "s/ /\+/g" | bc -l
}

function grade {
    local scores=$(get_scores $1)
    local total=$(get_total $1)
    local i=1
    for s in $scores
    do
        sed -i "s/puntuacion_$i/$s/" $1
        i=$(echo "$i+1" | bc -l)
    done
    local g=$(echo "scale=1; $total * 10 / ($i-1)" | bc -l)
    sed -i "s/puntuacion_total/$total/" $1
    sed -i "s/xcalificacionx/$g/" $1
}

#zip $1comments_backup.zip $1*comentarios.md

for hw in "$hwdir"*-commentaries.md
do
    echo "Grading: $hw"
    grade $hw
    comments_to_pdf $hw
    make_final_pdf $hw
done
