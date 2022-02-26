#!/bin/bash

echo "You are looking in $1"

for homework in $1tarea*.pdf

do
    echo $homework
    IFS='.'
    read -r name sufix <<< "$homework"
    touch $name-comentarios.md
done
