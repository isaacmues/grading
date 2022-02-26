#!/bin/bash

echo "The commentaries are in $1"

for homework in $1*comentarios.md
do
    name=$(echo $homework | grep -e '-[a-z_]\+-' -o)
    name=$(grep ${name:1:-1} $2 | cut -d , -f 2)
    hw_number=$(echo $homework | grep -e '[0-9]\+' -o)
    points=$(grep -e '([0-9.]\+ pts)' -o $homework | grep -e '[0-9.]\+' -o)
    total=$(echo $points | sed -e 's/ /\+/g' | bc -l)
    m=$(echo $points | wc -w)
    grade=$(echo "scale=1; $total * 10 / $m" | bc -l)
    n=0

    echo "# Tarea $hw_number de $name" >> $1calificacion-tmp
    echo "---" >> $1calificacion-tmp
    echo "## Calificación: $grade" >> $1calificacion-tmp
    echo -e "\n## Resumen\n" >> $1calificacion-tmp
    echo "| Ejercicio | Puntuación |" >> $1calificacion-tmp
    echo "| :-------: | :--------: |" >> $1calificacion-tmp

    for p in $points
    do
        n=$((n + 1))
        echo "| $n | $p |" >> $1calificacion-tmp
    done

    echo "| **Total** | $total |" >> $1calificacion-tmp
    echo -e "\n## Comentarios\n" >> $1calificacion-tmp

    cat $1calificacion-tmp $homework >> $homework
    rm $1calificacion-tmp
done
