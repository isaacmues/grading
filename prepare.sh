#!/bin/bash

if ["$1" = ""]; then
    echo "You need to input a valid path"
else
    cd $1
    for homework in tarea*.pdf
    do
        touch $(echo $homework | sed 's/.pdf/-comentarios.md/')
    done
fi
