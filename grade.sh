#!/bin/bash

grade (){
    name=$(echo $1 | grep -e '-[a-z_]\+-' -o)
    name=$(grep ${name:1:-1} $2 | cut -d , -f 2)
    hw_number=$(echo $1 | grep -e '_[0-9]\+-' -o)
    hw_number=${hw_number:1:-1}
    points=$(grep -e '([0-9.]\+ pts)' -o $1 | grep -e '[0-9.]\+' -o)
    total=$(echo $points | sed -e 's/ /\+/g' | bc -l)
    m=$(echo $points | wc -w)
    grade=$(echo "scale=1; $total * 10 / $m" | bc -l)
    n=0

    echo "# Tarea $hw_number de $name"
    echo "## Calificación: $grade" 
    echo -e "\n---\n" 
    echo -e "\n## Resumen\n" 
    echo "| Ejercicio | Puntuación |" 
    echo "| :-------: | :--------: |" 

    for p in $points
    do
        n=$((n + 1))
        echo "| $n | $p |" 
    done

    echo "| **Total** | $total |" 
    echo -e "\n## Comentarios\n" 
    cat $1
    echo -e "\n"
}

echo "The commentaries are in $1"
echo "Using: $2"

for homework in $1*comentarios.md
do
    grade $homework $2 >> tmp_grade
    mv tmp_grade $homework
done
