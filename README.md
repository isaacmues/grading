# Grading

Templates and scripts for grading homeworks

## How it works

The LuaTeX template and consists of two parts.
The `preamble.tex`, which contains the Lua code and some useful macros.
And the `template.tex`, which is designed to be copied for each work of the
students.

The compilation is done using the following command:

```
latexmk -pdf -pdflatex=lualatex file.tex
```
