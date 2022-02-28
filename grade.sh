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
    echo -e "## Resumen\n" 
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

comments2pd(){
    comments_pdf=$(echo $1 | sed 's/.md/.pdf/')
    pandoc -o $comments_pdf $1
}

makefinalpdf(){
    source_pdf=$(echo $1 | sed 's/-comentarios.md/.pdf/')
    comments_pdf=$(echo $1 | sed 's/.md/.pdf/')
    final_pdf=$(echo $1 | sed 's/comentarios.md/calificada.pdf/')
    pdfunite $comments_pdf $source_pdf $final_pdf
    rm $comments_pdf
}

echo "The commentaries are in $1"
echo "Using: $2"

zip $1comments_backup.zip $1*comentarios.md

for homework in $1*comentarios.md
do
    grade $homework $2 >> tmp_grade
    mv tmp_grade $homework
    comments2pd $homework
    makefinalpdf $homework
done
